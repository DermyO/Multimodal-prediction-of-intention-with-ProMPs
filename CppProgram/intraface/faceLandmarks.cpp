/*
 * Copyright (C) 2011 Department of Robotics Brain and Cognitive Sciences - Istituto Italiano di Tecnologia
 * Author: Vadim Tikhanoff
 * email:  vadim.tikhanoff@iit.it
 * Permission is granted to copy, distribute, and/or modify this program
 * under the terms of the GNU General Public License, version 2 or any
 * later version published by the Free Software Foundation.
 *
 * A copy of the license can be found at
 * http://www.robotcub.org/icub/license/gpl.txt
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details
 */

#include <yarp/sig/all.h>
#include "faceLandmarks.h"

/**********************************************************/
bool FACEModule::configure(yarp::os::ResourceFinder &rf)
{
    rf.setVerbose();
    moduleName = rf.check("name", yarp::os::Value("faceLandmarks"), "module name (string)").asString();
    predictorFile = rf.check("faceLandmarksFile", yarp::os::Value("shape_predictor_68_face_landmarks.dat"), "path name (string)").asString();

    std::string firstStr = rf.findFile(predictorFile.c_str());

    setName(moduleName.c_str());

    handlerPortName =  "/";
    handlerPortName += getName();
    handlerPortName +=  "/rpc:i";

    cntxHomePath = rf.getHomeContextPath().c_str();

    if (!rpcPort.open(handlerPortName.c_str()))
    {
        yError() << getName().c_str() << " Unable to open port " << handlerPortName.c_str();
        return false;
    }

    attach(rpcPort);
    closing = false;

    /* create the thread and pass pointers to the module parameters */
    faceManager = new FACEManager( moduleName, firstStr, cntxHomePath );

    /* now start the thread to do the work */
    faceManager->open();

    return true ;
}

/**********************************************************/
bool FACEModule::interruptModule()
{
    rpcPort.interrupt();
    return true;
}

/**********************************************************/
bool FACEModule::close()
{
    //rpcPort.close();
    yDebug() << "starting the shutdown procedure";
    faceManager->interrupt();
    faceManager->close();
    yDebug() << "deleting thread";
    delete faceManager;
    closing = true;
    yDebug() << "done deleting thread";
    return true;
}

/**********************************************************/
bool FACEModule::updateModule()
{
    return !closing;
}

/**********************************************************/
double FACEModule::getPeriod()
{
    return 0.01;
}

/************************************************************************/
bool FACEModule::attach(yarp::os::RpcServer &source)
{
    return this->yarp().attachAsServer(source);
}

/**********************************************************/
bool FACEModule::display(const std::string& value)
{
    if (value=="on")
    {
        faceManager->displayLandmarks=true;
        return true;
    }
    else if (value=="off")
    {
        faceManager->displayLandmarks = false;
        return true;
    }
    else
        return false;
}

/**********************************************************/
bool FACEModule::quit()
{
    closing = true;
    return true;
}

/**********************************************************/
FACEManager::~FACEManager()
{
}

/**********************************************************/
FACEManager::FACEManager( const std::string &moduleName,  const std::string &predictorFile, const std::string &cntxHomePath)
{
    yDebug() << "initialising Variables";
    this->moduleName = moduleName;
    this->predictorFile = predictorFile;
    this->cntxHomePath = cntxHomePath;
    yInfo() << "contextPATH = " << cntxHomePath.c_str();
}

/**********************************************************/
bool FACEManager::open()
{
    this->useCallback();

    //create all ports
    inImgPortName = "/" + moduleName + "/image:i";
    BufferedPort<yarp::sig::ImageOf<yarp::sig::PixelRgb> >::open( inImgPortName.c_str() );

    outImgPortName = "/" + moduleName + "/image:o";
    imageOutPort.open( outImgPortName.c_str() );

    outTargetPortName = "/" + moduleName + "/target:o";
    targetOutPort.open( outTargetPortName.c_str() );

    outLandmarksPortName = "/" + moduleName + "/landmarks:o";
    landmarksOutPort.open( outLandmarksPortName.c_str() );

    yDebug() << "path is: " << predictorFile.c_str();

    faceDetector = dlib::get_frontal_face_detector();
    dlib::deserialize(predictorFile.c_str()) >> sp;

    color = cv::Scalar( 0, 255, 0 );

    yarp::os::Network::connect("/icub/camcalib/left/out", "/faceLandmarks/image:i");
    yarp::os::Network::connect("/faceLandmarks/image:o", "/view/faces");

    displayLandmarks = true;

    return true;
}

/**********************************************************/
void FACEManager::close()
{
    mutex.wait();
    yDebug() <<"now closing ports...";
    imageOutPort.writeStrict();
    imageOutPort.close();
    imageInPort.close();
    targetOutPort.close();
    landmarksOutPort.close();
    BufferedPort<yarp::sig::ImageOf<yarp::sig::PixelRgb> >::close();
    mutex.post();
    yDebug() <<"finished closing the read port...";
}

/**********************************************************/
void FACEManager::interrupt()
{
    yDebug() << "cleaning up...";
    yDebug() << "attempting to interrupt ports";
    BufferedPort<yarp::sig::ImageOf<yarp::sig::PixelRgb> >::interrupt();
    yDebug() << "finished interrupt ports";
}

/**********************************************************/
void FACEManager::onRead(yarp::sig::ImageOf<yarp::sig::PixelRgb> &img)
{
    mutex.wait();
    yarp::sig::ImageOf<yarp::sig::PixelRgb> &outImg  = imageOutPort.prepare();
    yarp::os::Bottle &target=targetOutPort.prepare();
    yarp::os::Bottle &landmarks=landmarksOutPort.prepare();
    target.clear();

    // Get the image from the yarp port
    imgMat = cv::cvarrToMat((IplImage*)img.getIplImage());

    // Convert the opencv image to dlib format
    dlib::array2d<dlib::rgb_pixel> imgDlib;
    assign_image(imgDlib, dlib::cv_image<dlib::bgr_pixel>(imgMat));

    // Make the image larger so we can detect small faces. 2x
    pyramid_up(imgDlib);

    // Now tell the face detector to give us a list of bounding boxes
    // around all the faces in the image.
    std::vector<dlib::rectangle> dets = faceDetector(imgDlib);

    std::vector<dlib::full_object_detection> shapes;
    for (unsigned long j = 0; j < dets.size(); ++j)
    {
        dlib::full_object_detection shape = sp(imgDlib, dets[j]);
        shapes.push_back(shape);
    }

    cv::Mat gray = imgMat;
    cv::cvtColor(gray, gray, CV_BGR2GRAY);

    std::vector<std::pair<int, double >> idTargets;

    for (unsigned long i = 0; i < dets.size(); ++i)
    {
        DLIB_CASSERT(shapes[i].num_parts() == 68,
                     "\t std::vector<image_window::overlay_line> render_face_detections()"
                     << "\n\t Invalid inputs were given to this function. "
                     << "\n\t dets["<<i<<"].num_parts():  " << shapes[i].num_parts()
                     );

        const dlib::full_object_detection& d = shapes[i];

        if (displayLandmarks)
            drawLandmarks(imgMat, d);

        if (landmarksOutPort.getOutputCount()>0)
        {
            landmarks.clear();
            yarp::os::Bottle &landM = landmarks.addList();
            for (int f=1; f<shapes[i].num_parts(); f++)
            {
                if (f != 17 || f != 22 || f != 27 || f != 42 || f != 48)
                {
                    landM.addInt(d.part(f).x()/2);
                    landM.addInt(d.part(f).y()/2);
                }
             
            }
        }

        cv::Point pt1, pt2;
        pt1.x = dets[i].tl_corner().x()/2;
        pt1.y = dets[i].tl_corner().y()/2;
        pt2.x = dets[i].br_corner().x()/2;
        pt2.y = dets[i].br_corner().y()/2;

        rightEye.x = d.part(42).x()/2 + ((d.part(45).x()/2) - (d.part(42).x()/2))/2;
        rightEye.y = d.part(43).y()/2 + ((d.part(46).y()/2) - (d.part(43).y()/2))/2;
        leftEye.x  = d.part(36).x()/2 + ((d.part(39).x()/2) - (d.part(36).x()/2))/2;
        leftEye.y  = d.part(38).y()/2 + ((d.part(41).y()/2) - (d.part(38).y()/2))/2;

        //yDebug("rightEye %d %d leftEye %d %d ", rightEye.x, rightEye.y, leftEye.x, leftEye.y);

        //draw center of each eye
        circle(imgMat, leftEye , 2, cv::Scalar( 0, 0, 255 ), -1);
        circle(imgMat, rightEye , 2, cv::Scalar( 0, 0, 255 ), -1);

        double areaCalculation =0.0;
        areaCalculation = (std::fabs(pt2.x-pt1.x)*std::fabs(pt2.y-pt1.y));

        idTargets.push_back(std::make_pair(i, areaCalculation));
    }

    if (idTargets.size()>0)
    {
        std::sort(idTargets.begin(), idTargets.end(), [](const std::pair<int, double> &left, const std::pair<int, double> &right) {
            return left.second > right.second;
        });
    }

    if (dets.size() > 0 )
    {
        for (int i=0; i< idTargets.size(); i++)
        {
            cv::Point pt1, pt2;
            pt1.x = dets[idTargets[i].first].tl_corner().x()/2;
            pt1.y = dets[idTargets[i].first].tl_corner().y()/2;
            pt2.x = dets[idTargets[i].first].br_corner().x()/2;
            pt2.y = dets[idTargets[i].first].br_corner().y()/2;

            if (pt1.x < 2)
                pt1.x = 1;
            if (pt1.x > 318)
                pt1.x = 319;
            if (pt1.y < 2)
                pt1.y = 1;
            if (pt1.y > 238)
                pt1.y = 239;

            if (pt2.x < 2)
                pt2.x = 1;
            if (pt2.x > 318)
                pt2.x = 319;
            if (pt2.y < 2)
                pt2.y = 1;
            if (pt2.y > 238)
                pt2.y = 239;


            yarp::os::Bottle &pos = target.addList();
            pos.addDouble(pt1.x);
            pos.addDouble(pt1.y);
            pos.addDouble(pt2.x);
            pos.addDouble(pt2.y);

            cv::Point biggestpt1, biggestpt2;
            biggestpt1.x = dets[idTargets[0].first].tl_corner().x()/2;
            biggestpt1.y = dets[idTargets[0].first].tl_corner().y()/2;
            biggestpt2.x = dets[idTargets[0].first].br_corner().x()/2;
            biggestpt2.y = dets[idTargets[0].first].br_corner().y()/2;

           // rectangle(imgMat, biggestpt1, biggestpt2, cv::Scalar( 0, 255, 0 ), 1, 8, 0);

            targetOutPort.write();
            if (landmarksOutPort.getOutputCount()>0)
                landmarksOutPort.write();
        }
    }

    IplImage yarpImg = imgMat;
    outImg.resize(yarpImg.width, yarpImg.height);
    cvCopy( &yarpImg, (IplImage *) outImg.getIplImage());

    imageOutPort.write();

    mutex.post();
}

void FACEManager::drawLandmarks(cv::Mat &mat, const dlib::full_object_detection &d)
{
    //draw face contour, jaw
    //for (unsigned long i = 1; i <= 16; ++i)
      //  line(mat, cv::Point(d.part(i).x()/2, d.part(i).y()/2), cv::Point(d.part(i-1).x()/2, d.part(i-1).y()/2),  color);

    //draw right eyebrow
    //for (unsigned long i = 18; i <= 21; ++i)
      //  line(mat, cv::Point(d.part(i).x()/2, d.part(i).y()/2), cv::Point(d.part(i-1).x()/2, d.part(i-1).y()/2),  color);

    //draw left eyebrow
    //for (unsigned long i = 23; i <= 26; ++i)
      //  line(mat, cv::Point(d.part(i).x()/2, d.part(i).y()/2), cv::Point(d.part(i-1).x()/2, d.part(i-1).y()/2),  color);

    //draw nose
   // for (unsigned long i = 28; i <= 30; ++i)
        line(mat, cv::Point(d.part(29).x()/2, d.part(29).y()/2), cv::Point(d.part(28).x()/2, d.part(28).y()/2),  color);

    //draw nostrils
  //  line(mat, cv::Point(d.part(30).x()/2, d.part(30).y()/2), cv::Point(d.part(35).x()/2, d.part(35).y()/2),  color);
   // for (unsigned long i = 31; i <= 35; ++i)
     //   line(mat, cv::Point(d.part(i).x()/2, d.part(i).y()/2), cv::Point(d.part(i-1).x()/2, d.part(i-1).y()/2),  color);

    //draw right eye
    for (unsigned long i = 37; i <= 41; ++i)
        line(mat, cv::Point(d.part(i).x()/2, d.part(i).y()/2), cv::Point(d.part(i-1).x()/2, d.part(i-1).y()/2),  color);
    line(mat, cv::Point(d.part(36).x()/2, d.part(36).y()/2), cv::Point(d.part(41).x()/2, d.part(41).y()/2),  color);
        
         //cv::Point testPos;
        //testPos.x = d.part(36).x()/2 + ((d.part(41).x()/2) - (d.part(36).x()/2))/2;
        //testPos.y = d.part(36).y()/2 + ((d.part(41).y()/2) - (d.part(36).y()/2))/2;
		//circle(imgMat, testPos , 2, cv::Scalar( 255, 0, 0 ), -1);

    //draw left eye
    for (unsigned long i = 43; i <= 47; ++i)
        line(mat, cv::Point(d.part(i).x()/2, d.part(i).y()/2), cv::Point(d.part(i-1).x()/2, d.part(i-1).y()/2),  color);
    line(mat, cv::Point(d.part(42).x()/2, d.part(42).y()/2), cv::Point(d.part(47).x()/2, d.part(47).y()/2),  color);

    //draw outer mouth
    //for (unsigned long i = 49; i <= 59; ++i)
      //  line(mat, cv::Point(d.part(i).x()/2, d.part(i).y()/2), cv::Point(d.part(i-1).x()/2, d.part(i-1).y()/2),  color);
    //line(mat, cv::Point(d.part(48).x()/2, d.part(48).y()/2), cv::Point(d.part(59).x()/2, d.part(59).y()/2),  color);

    //draw inner mouth
    //line(mat, cv::Point(d.part(60).x()/2, d.part(60).y()/2), cv::Point(d.part(67).x()/2, d.part(67).y()/2),  color);
    //for (unsigned long i = 61; i <= 67; ++i)
       // line(mat, cv::Point(d.part(i).x()/2, d.part(i).y()/2), cv::Point(d.part(i-1).x()/2, d.part(i-1).y()/2),  color);

}
//empty line to make gcc happy
