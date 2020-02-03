# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.cache/wt [current_project]
set_property parent.project_path /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/prgmip32.coe
add_files /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/dmem32.coe
read_verilog -library xil_defaultlib {
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/control32_with_IO.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/dmemory32.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/executs32.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/idecode32.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/ifetc32.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/ioread.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/leds.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/memorio.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/switchs.v
  /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/imports/minisys/minisys.v
}
read_ip -quiet /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/ip/cpuclk/cpuclk.xci
set_property used_in_implementation false [get_files -all /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/ip/cpuclk/cpuclk_board.xdc]
set_property used_in_implementation false [get_files -all /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/ip/cpuclk/cpuclk.xdc]
set_property used_in_implementation false [get_files -all /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/ip/cpuclk/cpuclk_ooc.xdc]

read_ip -quiet /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/ip/prgrom/prgrom.xci
set_property used_in_implementation false [get_files -all /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/ip/prgrom/prgrom_ooc.xdc]

read_ip -quiet /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/ip/ram/ram.xci
set_property used_in_implementation false [get_files -all /home/stone/studio/minisys1_classfiles/minisys_impl/project_1/project_1.srcs/sources_1/ip/ram/ram_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top minisys -part xc7z020clg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef minisys.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file minisys_utilization_synth.rpt -pb minisys_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]