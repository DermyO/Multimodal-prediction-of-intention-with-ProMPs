# MultimodalTrajectoryInference

If you have some questions or remarks, please send an email to oriane.dermy@inria.fr. 

This program is the continuation of a previous [work](https://github.com/inria-larsen/icubLearningTrajectories), where robots* can learn probabilistic movement primitives that allows them, afer few early-observation of a movement guided physicaly by a human partner, to continue the movement expected by its partner.
In the current work, we add the sight modality to allow robots to have a prior information about which movement it has to do before the physical interaction with the human. Thus, the robot is able to predict more accurately the expected movement even when some learned movements are identical at the begining.

* We testes our software on the iCub robot even thought it can be used on other robots

## PRE-INSTALLATION and requirement:

This toolbox has been created on Ubuntu 16 with the iCubSim.  

You need to have installed:  
OpenCV2  
icub-main  
yarp  
gazebo  
WholeBodyDynamicsTree  
The Geomagic Touch software (see here: https://github.com/inria-larsen/icub-manual/wiki/Installation-with-the-Geomagic-Touch)  

A tutorial that explains how to install these modules is available at: https://github.com/inria-larsen/icub-manual/wiki/How-to-install-the-software-on-your-machine-(Ubuntu-16)
Note that wholeBodyDynamicsTree is currently included in the codyco-superbuild project.


## INSTALLATION:
`git clone https://github.com/inria-larsen/MultimodaltrajectoryInference` 
`cd MultimodaTrajectoryInference`   
`mkdir build`   
`cd build`   
`ccmake ../`   
`make install`   

Then, you can add some aliases to simplify the utilisation of our Gazebo world (that contains icubSim and some balls that represents the targets to reach). For example add these aliases:
alias gazebo_2goal="cd $SHARE_GAZEBO_MODELS/models/icub_with_two_vertical_targets && gazebo -slibgazebo_yarp_clock.so world2height.sdf"
alias gazebo_3goal="cd $SHARE_GAZEBO_MODELS/models/icub_with_three_vertical_targets && gazebo -slibgazebo_yarp_clock.so world3height.sdf"
alias gazebo_promps="cd $SHARE_GAZEBO_MODELS/models/icub_with_three_targets && gazebo -slibgazebo_yarp_clock.so worldPROMPS.sdf"
where $SHARE_GAZEBO_MODELS is the PATH where you have your Gazebo models installed (in our case is /home/icub/software/share/gazebo).

# Using only the touch modality
This correspond to our previous software. You can read how to use it in [this repository](https://github.com/inria-larsen/icubLearningTrajectories).
In the README.md file, you will find:
- Launching the Geomagic application
- Launching the program recordTrajectories.cpp
- Pre-traitment before using the Matlab scripts used to learn and infer trajectories.
- Launching the demo_plotProMP(s(Icub)) program
- Launching the demo_replayProMPs program
- Launching the demo_replayProMPsWithGeom program

# Using in addition the sight modality 
## Launching the head orientation program (C++)
/*Have to be completed: the xml file has to be updated.*/
