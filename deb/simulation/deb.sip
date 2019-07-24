set_global_assignment -entity "deb" -library "lib_deb" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "deb" -library "lib_deb" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "deb" -library "lib_deb" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_deb" -name SPD_FILE [file join $::quartus(sip_path) "../deb.spd"]
set_global_assignment -library "lib_deb" -name MISC_FILE [file join $::quartus(sip_path) "../../deb.qsys"]

set_global_assignment -library "lib_deb" -name MISC_FILE [file join $::quartus(sip_path) "deb.v"]
set_global_assignment -library "lib_deb" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altsource_probe.v"]
