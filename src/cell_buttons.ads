with Gtk.Toggle_Button; use Gtk.Toggle_Button;
with Glib; use Glib;

package Cell_Buttons is

   type Cell_Button_Record is new Gtk_Toggle_Button_Record with record
      X_Pos: Guint;
      Y_Pos: Guint;
   end record;
   type Cell_Button is access all Cell_Button_Record'Class;

   procedure Initialize(Button: Cell_Button; X_Pos: Guint; Y_Pos: Guint);

end Cell_Buttons;
