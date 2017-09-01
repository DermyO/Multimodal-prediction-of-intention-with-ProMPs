/*
 * Copyright (C) 2017 Inria Nancy
 * Author: Oriane Dermy
 * email:  oriane.dermy@inria.fr
 * 
 * Permission is granted to copy, distribute, and/or modify this program
 * under the terms of the GNU General Public License, version 2 or any
 * later version published by the Free Software Foundation.
 *
 * Inspired by human sensing (Vadim Tikhanoff; 2011 Department of Robotics Brain and Cognitive Sciences - Istituto Italiano di Tecnologia) & intraface
 * 
 * A copy of the license can be found at
 * http://www.robotcub.org/icub/license/gpl.txt
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details
 * 
 * 
 * In this function we retrieve the orientation of the head from iCub cam.
 */

#include "faceLandmarks.h"



bool compareRect(cv::Rect r1, cv::Rect r2) { return r1.height < r2.height; }

/**********************************************************/
bool FACEModule::configure(yarp::os::ResourceFinder &rf)
{
    rf.setVerbose();
    moduleName = rf.check("name", yarp::os::Value("faceIntraface"), "module name (string)").asString();
    //predictorFile = rf.check("faceIntrafaceFile", yarp::os::Value("shape_predictor_68_face_landmarks.dat"), "path name (string)").asString();

  //  std::string firstStr = rf.findFile(predictorFile.c_str());

    setName(moduleName.c_str());

    handlerPortName =  "/";
    handlerPortName += getName();
    handlerPortName +=  "/rpc:i";

    //cntxHomePath = rf.getHomeContextPath().c_str();

    if (!rpcPort.open(handlerPortName.c_str()))
    {
        yError() << getName().c_str() << " Unable to open port " << handlerPortName.c_str();
        return false;
    }

    attach(rpcPort);
    closing = false;

    /* create the thread and pass pointers to the module parameters */
    faceManager = new FACEManager( moduleName/*, firstStr, cntxHomePath */);

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
FACEManager::FACEManager( const std::string &moduleName/*,  const std::string &predictorFile, const std::string &cntxHomePath*/):
	xxd(4), fa(detectionModel, trackingModel, &xxd)
{
    yDebug() << "initialising Variables";
    this->moduleName = moduleName;
  //  this->predictorFile = predictorFile;
   // this->cntxHomePath = cntxHomePath;
   // yInfo() << "contextPATH = " << cntxHomePath.c_str();
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

    //outTargetPortName = "/" + moduleName + "/target:o";
  //  targetOutPort.open( outTargetPortName.c_str() );

    //outLandmarksPortName = "/" + moduleName + "/landmarks:o";
    //landmarksOutPort.open( outLandmarksPortName.c_str() );

  //  yDebug() << "path is: " << predictorFile.c_str();

    //faceDetector = dlib::get_frontal_face_detector();
   // dlib::deserialize(predictorFile.c_str()) >> sp;

   // yarp::os::Network::connect("/icub/camcalib/left/out", "/faceIntraface/image:i");
    //yarp::os::Network::connect("/faceIntraface/image:o", "/view/faces");

    //displayLandmarks = true;
     yDebug() << "intraface initialization...";
    
    /******Add intraface part********/
    std::string faceDetectionModel("/home/odermy/software/intraface/models/haarcascade_frontalface_alt2.xml");

    port.open("/headPos:o");
    
   
	// load OpenCV face detector model
	if( !face_cascade.load( faceDetectionModel ) )
	{ 
		cerr << "Error loading face detection model." << endl;
		return -1; 
	}
	
    return true;
}

/**********************************************************/
void FACEManager::close()
{
    mutex.wait();
    yDebug() <<"now closing ports...";
    port.close();
    imageOutPort.writeStrict();
    imageOutPort.close();
    imageInPort.close();
    //targetOutPort.close();
   // landmarksOutPort.close();
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


void FACEManager::sendPicture(cv::Mat frame,yarp::sig::ImageOf<yarp::sig::PixelRgb> &outImg)
{
	IplImage yarpImg = frame;
    outImg.resize(yarpImg.width, yarpImg.height);
    cvCopy( &yarpImg, (IplImage *) outImg.getIplImage());

    imageOutPort.write();

    mutex.post();
    //cout << "end onRead" << endl;
}

void drawPose(cv::Mat& img, const cv::Mat& rot, float lineL)
{
	int loc[2] = {70, 70};
	int thickness = 2;
	int lineType  = 8;

	cv::Mat P = (cv::Mat_<float>(3,4) << 
		0, lineL, 0,  0,
		0, 0, -lineL, 0,
		0, 0, 0, -lineL);
	P = rot.rowRange(0,2)*P;
	P.row(0) += loc[0];
	P.row(1) += loc[1];
	cv::Point p0(P.at<float>(0,0),P.at<float>(1,0));

	line(img, p0, cv::Point(P.at<float>(0,1),P.at<float>(1,1)), cv::Scalar( 255, 0, 0 ), thickness, lineType);
	line(img, p0, cv::Point(P.at<float>(0,2),P.at<float>(1,2)), cv::Scalar( 0, 255, 0 ), thickness, lineType);
	line(img, p0, cv::Point(P.at<float>(0,3),P.at<float>(1,3)), cv::Scalar( 0, 0, 255 ), thickness, lineType);
}
/**********************************************************/
void FACEManager::onRead(yarp::sig::ImageOf<yarp::sig::PixelRgb> &img)
{
	
	//cout << "beging onRead" << endl;
    mutex.wait();
    yarp::sig::ImageOf<yarp::sig::PixelRgb> &outImg  = imageOutPort.prepare();
    //yarp::os::Bottle &target=targetOutPort.prepare();
    //yarp::os::Bottle &landmarks=landmarksOutPort.prepare();
    //target.clear();

    // Get the image from the yarp port
    frame = cv::cvarrToMat((IplImage*)img.getIplImage());

	if (frame.rows == 0 || frame.cols == 0)
	{
		cout << "frame rows /cols =0" << endl;
		sendPicture(frame, outImg);
		return;
	}			
	
	// face detection
	vector<cv::Rect> faces;
	face_cascade.detectMultiScale(frame, faces, 1.2, 2, 0, cv::Size(50, 50));
	

	// if no face found, do nothing
	if (faces.empty()) {
		cout << "face is empty" << endl;
		sendPicture(frame, outImg);
		return ;
	}
	
	// facial feature detection on largest face found
	if (fa.Detect(frame,*max_element(faces.begin(),faces.end(),compareRect),X0,score) != INTRAFACE::IF_OK)
		{
			sendPicture(frame, outImg);
		return;
	}

	if (isDetect)
	{
		// face detection
		face_cascade.detectMultiScale(frame, faces, 1.2, 2, 0, cv::Size(50, 50));
		// if no face found, do nothing
		if (faces.empty()) {
			cout << "before wait... ";
			key = cv::waitKey(5);
			cout << "after wait." << endl;
			sendPicture(frame, outImg);
			return;
		}
		
		
		// facial feature detection on largest face found
		if (fa.Detect(frame,*max_element(faces.begin(),faces.end(),compareRect),X0,score) != INTRAFACE::IF_OK)
		{
			 FACEManager::close();
			 sendPicture(frame, outImg);
			 return;
		 }
		isDetect = false;
	}
	else
	{
		// facial feature tracking
		if (fa.Track(frame,X0,X,score) != INTRAFACE::IF_OK)
			 FACEManager::close();
		X0 = X;
	}

	// head pose estimation
	INTRAFACE::HeadPose hp;
	fa.EstimateHeadPose(X0,hp);
	yarp::os::Bottle *input = port.read();
	//if(verbositylevel == 1) cout << "Receive command." << endl;
	if(input->get(0).asDouble() == -1.0) // if we receive -1 we close the program
	 {
	//	if(verbositylevel == 1) cout << "Receive command to close the programm." << endl;
		{
		 FACEManager::close();
		 return;
		}
	 }
	 else if(input->get(0).asDouble() == 1.0) // if we receive 0 we go back to initial position
	 {
	//	if(verbositylevel == 1) cout << "Receive ask to send information" << endl;
		//	cout << hp.angles[0] << " " << hp.angles[1] << " " << hp.angles[2] << endl;
		yarp::os::Bottle &out = port.prepare();
	    out.clear();
	    out.addDouble(hp.angles[0]);
	    out.addDouble(hp.angles[1]);
	    out.addDouble(hp.angles[2]);
	  //  cout << "Sending " << out.toString().c_str() << endl;
	    
	    // send the message
		port.write(true);
		
		
	    //cv::Point P1, P2, EL, ER; //EL ER = Centre
	    /**************To draw the face *************/
    	//for (int i = 0; i < 9; i++) //eyebrows
		//{
			//if (i==4) continue;

			////val1 = (int)(frame.rows/2)+ (int)X0.at<float>(1,i)-(int)X0.at<float>(1,10) ; 
			////cout << "val2 = " << val1 << endl;
			//P1 = cv::Point((int)(frame.cols/2)+ (int)X0.at<float>(0,i) /*- (int)X0.at<float>(0,10)*/, (int)(frame.rows/2)+ (int)X0.at<float>(1,i)/*-(int)X0.at<float>(1,10)*/ );
			//P2 = cv::Point((int)(frame.cols/2) + (int)X0.at<float>(0,i+1) /*- (int)X0.at<float>(0,10)*/, (int)(frame.rows/2)+ (int)X0.at<float>(1,i+1)/*-(int)X0.at<float>(1,10)*/ );
			//cv::line(frame/*image*/,P1,P2 , cv::Scalar(0,0,0)/*couleur*/, 3);
		//}
		/*
		for(int i=15; i<17;i++) //noze
		{
			
			P1 = cv::Point((int)(frame.cols/2)+ (int)X0.at<float>(0,i) - (int)X0.at<float>(0,10), (int)(frame.rows/2)+ (int)X0.at<float>(1,i)-(int)X0.at<float>(1,10) );
			P2 = cv::Point((int)(frame.cols/2) + (int)X0.at<float>(0,i+1) - (int)X0.at<float>(0,10), (int)(frame.rows/2)+ (int)X0.at<float>(1,i+1)-(int)X0.at<float>(1,10) );
			cv::line(frame,P1,P2 , cv::Scalar(0,0,0),3);
		}
		for(int i=43; i<48; i++)
		{
			P1 = cv::Point((int)(frame.cols/2)+ (int)X0.at<float>(0,i) - (int)X0.at<float>(0,10), (int)(frame.rows/2)+ (int)X0.at<float>(1,i)-(int)X0.at<float>(1,10) );
			P2 = cv::Point((int)(frame.cols/2) + (int)X0.at<float>(0,i+1) - (int)X0.at<float>(0,10), (int)(frame.rows/2)+ (int)X0.at<float>(1,i+1)-(int)X0.at<float>(1,10) );
			cv::line(frame,P1,P2 , cv::Scalar(0,0,0),3);
		}
	
		P1 = cv::Point((int)(frame.cols/2)+ (int)X0.at<float>(0,48) - (int)X0.at<float>(0,10), (int)(frame.rows/2)+ (int)X0.at<float>(1,48)-(int)X0.at<float>(1,10) );
		P2 = cv::Point((int)(frame.cols/2) + (int)X0.at<float>(0,43) - (int)X0.at<float>(0,10), (int)(frame.rows/2)+ (int)X0.at<float>(1,43)-(int)X0.at<float>(1,10) );
		cv::line(frame,P1,P2 , cv::Scalar(0,0,0),3);
		
		//creation des yeux
	//	if(count > 200)
	//	{
			//P1= cv::Point((int)(frame.cols/2) + 7 - (int)X0.at<float>(0,10) +((int)X0.at<float>(0,19)+(int)X0.at<float>(0,22))/2, (int)(frame.rows/2)-(int)X0.at<float>(1,10) +((int)X0.at<float>(1,19) + (int)X0.at<float>(1,19))/2);
			//P2 = cv::Point((int)(frame.cols/2)+ 7 - (int)X0.at<float>(0,10) +((int)X0.at<float>(0,25)+(int)X0.at<float>(0,28))/2, (int)(frame.rows/2)-(int)X0.at<float>(1,10) +((int)X0.at<float>(1,25) + (int)X0.at<float>(1,28))/2);
			//EL = cv::Point((int)(frame.cols/2) - (int)X0.at<float>(0,10) +((int)X0.at<float>(0,19)+(int)X0.at<float>(0,22))/2, (int)(frame.rows/2)-(int)X0.at<float>(1,10) +((int)X0.at<float>(1,19) + (int)X0.at<float>(1,19))/2);
			//ER = cv::Point((int)(frame.cols/2) - (int)X0.at<float>(0,10) +((int)X0.at<float>(0,25)+(int)X0.at<float>(0,28))/2, (int)(frame.rows/2)-(int)X0.at<float>(1,10) +((int)X0.at<float>(1,25) + (int)X0.at<float>(1,28))/2);
			//cv::line(frame,EL,P1, cv::Scalar(0,0,0), 3);
			//cv::line(frame,ER,P2, cv::Scalar(0,0,0), 3);

//		}
		//else{
		EL = cv::Point((int)(frame.cols/2) - (int)X0.at<float>(0,10) +((int)X0.at<float>(0,19)+(int)X0.at<float>(0,22))/2, (int)(frame.rows/2)-(int)X0.at<float>(1,10) +((int)X0.at<float>(1,19) + (int)X0.at<float>(1,19))/2);
		ER = cv::Point((int)(frame.cols/2) - (int)X0.at<float>(0,10) +((int)X0.at<float>(0,25)+(int)X0.at<float>(0,28))/2, (int)(frame.rows/2)-(int)X0.at<float>(1,10) +((int)X0.at<float>(1,25) + (int)X0.at<float>(1,28))/2);
		cv::circle(frame,EL, 10, cv::Scalar(0,0,0), -1); // frame, centre, radian, couleur
		cv::circle(frame,ER, 10, cv::Scalar(0,0,0) -1);
		//}
		*/
		//// head pose estimation
		//INTRAFACE::HeadPose hp;
		//fa.EstimateHeadPose(X0,hp);
		// plot head pose
		
		//cout << "drawPose" << endl;
		//drawPose(frame, hp.rot, 50);
		/************END Drawing *************/
	    
	    
	    
	    
	}

	sendPicture(frame, outImg);

}

