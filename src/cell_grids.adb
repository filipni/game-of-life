package body Cell_Grids is
   
   function Get_Next_Iteration(Cells: Cell_Grid) return Cell_Grid is
      Alive: Boolean;
      Living_Neighbours: Natural;
      Updated_Cell_Grid: Cell_Grid := (others => (others => False));
   begin
      for I in Grid_Index loop
         for J in Grid_Index loop           
            Alive := Cells(I, J);
            Living_Neighbours := Get_Number_Of_Living_Neighbours(Cells, I, J);          
            if Alive and (Living_Neighbours = 2 or Living_Neighbours = 3) then
               Updated_Cell_Grid(I, J) := True;
            elsif not Alive and Living_Neighbours = 3 then
               Updated_Cell_Grid(I, J) := True;
            end if;           
         end loop;
      end loop;   
      return Updated_Cell_Grid;
   end Get_Next_Iteration;
   
   function Get_Number_Of_Living_Neighbours(Cells: Cell_Grid; X_Pos: Grid_Index; Y_Pos: Grid_Index) return Natural is
      X_Index: Grid_Index;
      Y_Index: Grid_Index;
      Counter: Natural := 0;
   begin
      X_Index := X_Pos-1;
      for I in 1 .. 3 loop
         Y_Index := Y_Pos-1;
         for J in 1 .. 3 loop
            if Cells(X_Index, Y_Index) then
               Counter := Counter + 1;
            end if;
            Y_Index := Y_Index + 1;
         end loop;
         X_Index := X_Index + 1;
      end loop;
      
      if Cells(X_Pos, Y_Pos) then
         Counter := Counter-1;
      end if;
      
      return Counter;   
   end Get_Number_Of_Living_Neighbours;
   
end Cell_Grids;
