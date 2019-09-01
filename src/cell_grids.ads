package Cell_Grids is

   type Grid_Index is mod 25;
   type Cell_Grid is array (Grid_Index, Grid_Index) of Boolean;
   
   function Get_Next_Iteration(Cells: Cell_Grid) return Cell_Grid;   
   
private

   function Get_Number_Of_Living_Neighbours(Cells: Cell_Grid; X_Pos: Grid_Index; Y_Pos: Grid_Index) return Natural; 

end Cell_Grids;
