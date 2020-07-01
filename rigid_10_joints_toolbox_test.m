close all
clear all
clc
%% Create Rigid Body Obj.
robot = robotics.RigidBodyTree('DataFormat','column','MaxNumBodies',3);
%J1
body = robotics.RigidBody('link1');
joint = robotics.Joint('joint1', 'revolute');
setFixedTransform(joint,[0 -pi/2 0 0],'dh');
joint.JointAxis = [0 0 1];
body.Joint = joint;
addBody(robot, body, 'base');
%J2
body = robotics.RigidBody('link2');
joint = robotics.Joint('joint2','revolute');
setFixedTransform(joint,[0 pi/2 0 0],'dh');
joint.JointAxis = [0 0 1];
body.Joint = joint;
addBody(robot, body, 'link1');
%J3
body = robotics.RigidBody('link3');
joint = robotics.Joint('joint3','prismatic');
setFixedTransform(joint,[0 0 0 0],'dh');
joint.JointAxis = [0 0 1];
body.Joint = joint;
addBody(robot, body, 'link2');
%J4
body = robotics.RigidBody('link4');
joint = robotics.Joint('joint4', 'revolute');
setFixedTransform(joint,trvec2tform([0 0 0]));
setFixedTransform(joint,[0 0 0 0],'dh');
body.Joint = joint;
addBody(robot, body, 'link3');
%J5
body = robotics.RigidBody('link5');
joint = robotics.Joint('joint5', 'revolute');
setFixedTransform(joint,[0 0 0 0],'dh');
body.Joint = joint;
addBody(robot, body, 'link4');
%J6
body = robotics.RigidBody('link6');
joint = robotics.Joint('joint6', 'prismatic');
setFixedTransform(joint,[0 -pi/2 0 0],'dh');
body.Joint = joint;
addBody(robot, body, 'link5');
%J7
body = robotics.RigidBody('link7');
joint = robotics.Joint('joint7', 'revolute');
setFixedTransform(joint,[0 pi/2 0 0],'dh');
body.Joint = joint;
addBody(robot, body, 'link6');
%J8
body = robotics.RigidBody('link8');
joint = robotics.Joint('joint8', 'revolute');
setFixedTransform(joint,[0 0 0 0],'dh');
body.Joint = joint;
addBody(robot, body, 'link7');
%% RRPR-RPRR 8-DOFs
phi_rad=deg2rad(90);
theta_rad=deg2rad(90);
showdetails(robot)
figure(1)
show(robot,[phi_rad,theta_rad/2,0.17,-phi_rad,phi_rad,0.17,theta_rad/2,-phi_rad]');

