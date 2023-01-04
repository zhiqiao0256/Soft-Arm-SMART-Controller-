# Install script for directory: /home/zq/colcon_ws/src/vrpn-ros2

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/zq/colcon_ws/install/vrpn")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "RelWithDebInfo")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xserversdkx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/zq/colcon_ws/build/vrpn/libvrpnserver.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xserversdkx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/home/zq/colcon_ws/build/vrpn/vrpn_Configure.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Analog.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Analog_Output.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Assert.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Auxiliary_Logger.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_BaseClass.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Button.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Connection.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ConnectionPtr.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Dial.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_EndpointContainer.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_FileConnection.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_FileController.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ForceDevice.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ForwarderController.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Forwarder.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_FunctionGenerator.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Imager.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_LamportClock.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Log.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_MainloopContainer.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_MainloopObject.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Mutex.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_OwningPtr.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_RedundantTransmission.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_SendTextMessageStreamProxy.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Serial.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_SerialPort.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Shared.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_SharedObject.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Sound.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Text.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Thread.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Types.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_WindowsH.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_3DConnexion.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_3DMicroscribe.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_3Space.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_5DT16.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Adafruit.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ADBox.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Analog_5dt.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Analog_5dtUSB.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Analog_Radamec_SPI.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Analog_USDigital_A2.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Atmel.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_BiosciencesTools.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Button_NI_DIO24.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Button_USB.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_CerealBox.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_CHProducts_Controller_Raw.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Contour.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_DevInput.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_DirectXFFJoystick.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_DirectXRumblePad.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_DreamCheeky.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Dyna.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Event_Analog.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Event.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Event_Mouse.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Flock.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Flock_Parallel.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ForceDeviceServer.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Freespace.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_FunctionGenerator.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Futaba.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_GlobalHapticsOrb.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Griffin.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_HashST.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_HumanInterface.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_IDEA.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Imager_Stream_Buffer.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ImmersionBox.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_inertiamouse.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_JoyFly.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Joylin.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Joywin32.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Keyboard.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Logitech_Controller_Raw.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Laputa.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_LUDL.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Magellan.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_MessageMacros.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Microsoft_Controller_Raw.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Mouse.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_NationalInstruments.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Nidaq.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_nikon_controls.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_nVidia_shield_controller.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Oculus.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_OmegaTemperature.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_OneEuroFilter.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_OzzMaker.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Poser_Analog.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Poser.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Poser_Tek4662.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_raw_sgibox.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Retrolink.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Saitek_Controller_Raw.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_sgibox.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Spaceball.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Streaming_Arduino.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tng3.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_3DMouse.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_AnalogFly.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_ButtonFly.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_Crossbow.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_DTrack.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_Fastrak.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_Filter.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_GameTrak.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_GPS.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_IMU.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_isense.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_Isotrak.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_JsonNet.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_Liberty.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_MotionNode.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_NDI_Polaris.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_NovintFalcon.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_OSVRHackerDevKit.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_PDI.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_PhaseSpace.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_RazerHydra.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_ThalmicLabsMyo.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_SpacePoint.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_Wintracker.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_Colibri.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_TrivisioColibri.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_WiimoteHead.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_zSight.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_ViewPoint.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_UNC_Joystick.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_VPJoystick.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Wanda.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_WiiMote.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_XInputGamepad.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Xkeys.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker_LibertyHS.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_YEI_3Space.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Zaber.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/server_src/vrpn_Generic_server_object.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/vrpn" TYPE FILE FILES "/home/zq/colcon_ws/src/vrpn-ros2/package.xml")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/vrpn/cmake" TYPE FILE RENAME "VRPNConfig.cmake" FILES "/home/zq/colcon_ws/src/vrpn-ros2/cmake/FindVRPN.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/quatlib/cmake" TYPE FILE RENAME "quatlibConfig.cmake" FILES "/home/zq/colcon_ws/src/vrpn-ros2/cmake/Findquatlib.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xclientsdkx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/zq/colcon_ws/build/vrpn/libvrpn.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xclientsdkx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/home/zq/colcon_ws/build/vrpn/vrpn_Configure.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Analog.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Analog_Output.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Assert.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Auxiliary_Logger.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_BaseClass.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Button.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Connection.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ConnectionPtr.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Dial.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_EndpointContainer.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_FileConnection.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_FileController.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ForceDevice.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_ForwarderController.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Forwarder.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_FunctionGenerator.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Imager.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_LamportClock.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Log.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_MainloopContainer.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_MainloopObject.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Mutex.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_OwningPtr.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_RedundantTransmission.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_SendTextMessageStreamProxy.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Serial.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_SerialPort.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Shared.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_SharedObject.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Sound.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Text.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Thread.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Tracker.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_Types.h"
    "/home/zq/colcon_ws/src/vrpn-ros2/vrpn_WindowsH.h"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/zq/colcon_ws/build/vrpn/quat/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/submodules/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/atmellib/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/gpsnmealib/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/client_src/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/server_src/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/util/printStream/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/doxygen/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/python_vrpn/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/python/cmake_install.cmake")
  include("/home/zq/colcon_ws/build/vrpn/java_vrpn/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/zq/colcon_ws/build/vrpn/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
