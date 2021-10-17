//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <dropfiles_window/dropfiles_window_plugin.h>
#include <musicplayer_plugin/musicplayer_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  DropfilesWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DropfilesWindowPlugin"));
  MusicplayerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MusicplayerPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
