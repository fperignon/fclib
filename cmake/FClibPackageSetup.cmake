# =========== uninstall target ===========
configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
  IMMEDIATE @ONLY)
#add_custom_target(uninstall
#  echo >> ${CMAKE_CURRENT_BINARY_DIR}/install_manifest.txt
#  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

# ===== Package configuration file ====
# https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#creating-packages
# 
include(CMakePackageConfigHelpers)

# Generate ${PROJECT_NAME}Config.cmake
configure_package_config_file(fclib-config.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/fclib-config.cmake
  INSTALL_DESTINATION ${ConfigPackageLocation})

# Generate fclib-config-version.cmake file.
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/fclib-config-version.cmake"
  VERSION ${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}
  COMPATIBILITY SameMajorVersion
  )

if(NOT FCLIB_HEADER_ONLY)
message("CREATE ${CMAKE_CURRENT_BINARY_DIR}/fclibTargets.cmake")

get_property(result DIRECTORY PROPERTY BUILDSYSTEM_TARGETS )
message("result is ${result}")
  export(EXPORT fclibTargets
    FILE "${CMAKE_CURRENT_BINARY_DIR}/fclibTargets.cmake"
    NAMESPACE FCLIB::
    )
    if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/fclibTargets.cmake  )
      message("FILE IS THERE !!!")
      file(READ ${CMAKE_CURRENT_BINARY_DIR}/fclibTargets.cmake TMPFILE )
      message("FILE IS ${TMPFILE}")
   
    else()
      message("PERDI!!!")
  endif() 
 
  install(EXPORT fclibTargets
    NAMESPACE FCLIB::
    DESTINATION ${ConfigPackageLocation}) 
endif()
if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/fclibTargets.cmake  )
message("FILE 111 IS THERE !!!")
file(READ ${CMAKE_CURRENT_BINARY_DIR}/fclibTargets.cmake TMPFILE )
message("FILE I 111 S ${TMPFILE}")
  
else()
message("PERD1111 I!!!")
endif() 


# install config files
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/fclib-config.cmake ${CMAKE_CURRENT_BINARY_DIR}/fclib-config-version.cmake
  DESTINATION ${ConfigPackageLocation})

# pkg-config file
if(NOT SKIP_PKGCONFIG)
  if(NOT FCLIB_HEADER_ONLY)
    set(PKGCONFIG_LIBS "-L\${libdir} -lfclib")
  endif()
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}.pc.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc"
    @ONLY)
  set(INSTALL_PKGCONFIG_DIR "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/pkgconfig"
    CACHE PATH "Installation directory for pkgconfig (.pc) files")
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc
    DESTINATION "${INSTALL_PKGCONFIG_DIR}")
endif()

