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

int main(int argc, char * argv[])
{
    /* initialize yarp network */
    yarp::os::Network::init();
    
    yarp::os::Network yarp;
    if (!yarp.checkNetwork())
    {
        yError()<<"YARP server not available!";
        return 1;
    }

    /* create the module */
    FACEModule module;

    /* prepare and configure the resource finder */
    yarp::os::ResourceFinder rf;
    rf.setVerbose( true );
    rf.setDefaultContext( "faceIntraface" );
    rf.setDefaultConfigFile( "faceIntraface.ini" );
    rf.setDefault("name","faceIntraface");
    
    rf.configure( argc, argv );

    /* run the module: runModule() calls configure first and, if successful, it then runs */
    module.runModule(rf);
    yarp::os::Network::fini();

    return 0;
}
//empty line to make gcc happy
