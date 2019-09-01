package body Cell_Buttons is
   
   procedure Initialize(Button: Cell_Button; X_Pos: Guint; Y_Pos: Guint) is 
   begin
      Gtk.Toggle_Button.Initialize(Button, "     ");
      Button.X_Pos := X_Pos;
      Button.Y_Pos := Y_Pos;
   end Initialize;
   
end Cell_Buttons;
