with Gtk.Main; use Gtk.Main;
with Gtk.Handlers; use Gtk.Handlers;
with Gtk.Button; use Gtk.Button;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Window; use Gtk.Window;
with Gtk.Table; use Gtk.Table;
with Gtk.Enums;

with Gdk.Event; use Gdk.Event;
with Gdk.Color;

with Glib; use Glib;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;

with Cell_Grids; use Cell_Grids;
with Cell_Buttons; use Cell_Buttons;

procedure Main is
   Window: Gtk_Window;
   Start_Button: Gtk_Button;
   Stop_Button: Gtk_Button;
   Table: Gtk_Table;

   Timeout_Id: Timeout_Handler_Id;
   Game_Started: Boolean := False;
   Cell: Cell_Button;
   Cell_Map: Cell_Grid := (others => (others => False));

   type Button_Grid is array (Grid_Index, Grid_Index) of Cell_Button;
   Cell_Button_Grid: Button_Grid;

   package Return_Handlers is new Gtk.Handlers.Return_Callback
     (Widget_Type => Gtk_Widget_Record,
      Return_Type => Boolean);

   package Cell_Handlers is new Gtk.Handlers.Callback
     (Widget_Type => Cell_Button_Record);

   package Start_Stop_Handlers is new Gtk.Handlers.Callback
     (Widget_Type => Gtk_Widget_Record);

   package My_Timeout is new Gtk.Main.Timeout(Data_Type => Button_Grid);

   function Table_Callback(Buttons: Button_Grid) return Boolean is
      Grid_Button: Cell_Button;
   begin
      Cell_Map := Get_Next_Iteration(Cell_Map);
      for I in Grid_Index loop
         for J in Grid_Index loop
            Grid_Button := Buttons(I, J);
            Grid_Button.Set_Active(Cell_Map(I,J));
         end loop;
      end loop;
      return True;
   end Table_Callback;

   procedure Start_Callback(Widget: access Gtk_Widget_Record'Class) is
   begin
      if not Game_Started then
         Timeout_Id := My_Timeout.Add(Interval => 120,
                                      Func     => Table_Callback'Access,
                                      D        => Cell_Button_Grid);
         Game_Started := True;
      end if;
   end Start_Callback;

   procedure Stop_Callback(Widget: access Gtk_Widget_Record'Class) is
   begin
      if Game_Started then
         Timeout_Remove(Timeout_Id);
         Game_Started := False;
      end if;
   end Stop_Callback;

   procedure Cell_Callback(Button: access Cell_Button_Record'Class) is
   begin
      Cell_Map(Grid_Index(Button.X_Pos), Grid_Index(Button.Y_Pos)) := Button.Get_Active;
   end Cell_Callback;

   function Delete_Event
     (Widget : access Gtk_Widget_Record'Class;
      Event  : Gdk_Event) return Boolean
   is
      pragma Unreferenced (Event);
      pragma Unreferenced (Widget);
   begin
      Gtk.Main.Main_Quit;
      return False;
   end Delete_Event;

   procedure Setup_Window is
      Foo: Boolean;
   begin
      Gtk.Window.Gtk_New (Window);
      Window.Set_Title("Game of Life");
      Window.Set_Resizable(False);
      begin
         Foo := Gtk.Window.Set_Icon_From_File(Window, "glider.png");
      exception
         when E : Storage_Error =>
            Put_Line("Window icon not found.");
      end;
      Return_Handlers.Connect(Window, "delete_event", Return_Handlers.To_Marshaller(Delete_Event'Access));

   end Setup_Window;

   procedure Setup_Grid is
      Grid_Size: Guint := Guint(Grid_Index'Last);
      Color: Gdk.Color.Gdk_Color := Gdk.Color.Parse("black");
   begin
      Gtk_New(Table, Grid_Size + 2, Grid_Size, True);
      Window.Add(Table);
      for I in 0 .. Grid_Size loop
         for J in 0 .. Grid_Size loop
            Cell := new Cell_Button_Record;
            Cell_Buttons.Initialize(Cell, I, J);
            Gtk.Widget.Modify_Bg(Gtk_Widget(Cell), Gtk.Enums.State_Active, Color);
            Gtk.Widget.Modify_Bg(Gtk_Widget(Cell), Gtk.Enums.State_Prelight, Color);
            Cell_Handlers.Connect(Cell, "clicked", Cell_Handlers.To_Marshaller(Cell_Callback'Access));
            Cell_Button_Grid(Grid_Index(I), Grid_Index(J)) := Cell;
            Table.Attach(Cell, I, I+1, J, J+1);
         end loop;
      end loop;

      Gtk_New(Start_Button, "Start");
      Start_Stop_Handlers.Connect(Start_Button, "clicked", Start_Stop_Handlers.To_Marshaller(Start_Callback'Access));
      Table.Attach(Start_Button, 0, Grid_Size+1, Grid_Size+1, Grid_Size+2);

      Gtk_New(Stop_Button, "Stop");
      Start_Stop_Handlers.Connect(Stop_Button, "clicked", Start_Stop_Handlers.To_Marshaller(Stop_Callback'Access));
      Table.Attach(Stop_Button, 0, Grid_Size+1, Grid_Size+2, Grid_Size+3);
   end Setup_Grid;

begin
   Gtk.Main.Init;
   Setup_Window;
   Setup_Grid;
   Window.Show_All;
   Gtk.Main.Main;
end Main;
