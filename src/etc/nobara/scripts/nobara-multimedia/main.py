#! /usr/bin/python3
import gi
gi.require_version("Gtk", "3.0")
gi.require_version("Vte", "2.91")
from gi.repository import Gtk, GObject, Vte, GLib
import os, subprocess, time, threading


hasffmpeg = subprocess.run(["dnf list installed | grep -i ffmpeg-libs"], shell=True)

class Application(Gtk.ApplicationWindow):
	### MAIN WINDOW ###
	def __init__(self):
 
		self.column_names = False
		self.drop_nan = False
		self.df = None
		application_id="nobara.nobara.multimedia"

		self.builder = Gtk.Builder()
		self.builder.add_from_file("/etc/nobara/scripts/nobara-multimedia/main.ui")
		self.builder.connect_signals(self)

		self.window = self.builder.get_object("main_window")
		self.window.show()

		self.main_box = self.builder.get_object("main_box")
		self.top_box = self.builder.get_object("top_box")
		self.buttom_box = self.builder.get_object("buttom_box")
		self.center_text = self.builder.get_object("center_text")
		self.btn_decline = self.builder.get_object("btn_decline")
		self.btn_accept = self.builder.get_object("btn_accept")
		self.status_logo = self.builder.get_object("status_logo")
		self.topbar_text = self.builder.get_object("topbar_text")

		win = self.builder.get_object("main_window")
		win.connect("destroy", Gtk.main_quit)

		self.window = self.builder.get_object("main_window")
		self.window.show()
		
		if (hasffmpeg.returncode) != 0:
			self.center_text.set_label("Due to U.S. patent laws we are not able to include some important video playback and encoding packages\n on the Nobara installation media, -HOWEVER- these are freely\navailable to download and install with your consent, which we are asking for now! \nPlease note that without these packages installed, video playback in some games, browsers,\nand media players will not work correctly. Additionally, without these packages you will\nbe unable to use video encoding in OBS studio and Blender.\n\n\nWould you like to install the required video playback and encoding packages now to resolve\nthe issue? (strongly recommended)")
			self.status_logo.set_from_icon_name("media-tape", 64)
			self.btn_decline.set_sensitive(True)
			self.btn_accept.set_sensitive(True)
		else:
			exit(1)
 
	def on_btn_decline_pressed(self, widget):
		self.builder.get_object("main_window").set_visible(False)
		os.system("zenity --info --title='Video Playback and Encoding enablement' --width=600 --text='We will not ask again until your next reboot'.")
		Gtk.main_quit()
	def on_btn_accept_pressed(self, widget):
		self.builder.get_object("main_window").set_visible(False)
		def install():
			os.system("python3 /etc/nobara/scripts/nobara-multimedia/process.py install")
		t1 = threading.Thread(target=install)
		t1.start()
		Gtk.main_quit()

Application()
Gtk.main()
