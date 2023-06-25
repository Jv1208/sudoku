program sudoku;
uses crt;

    
       

 
const LEFT  = 14;
      UP    = 4;
      SPACE= ' ';
   DAT_FILE = 'sudoku.dat';
       COL1 = DarkGray;
       COL2 = LIGHTGRAY;
      COLBG = blue;
 
var   s: array[1..9,1..9,0..9] of byte;
    x,y: integer;
     ch: char;
     
     
     

procedure writexy(x,y:integer; s:string);

   begin
   
  gotoxy(x,y);
  write(s);
end;
 

 
{ver plano de sudoku  }
 

procedure ViewSudoku;
begin

  
  textcolor(COL1);
                      
  writexy( LEFT, UP   ,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+ 1,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+ 2,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+ 3,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+ 4,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+ 5,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+ 6,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+ 7,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+ 8,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+ 9,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+10,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+11,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+12,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+13,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+14,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+15,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+16,  'ooooooooooooooooooooooooooooooooooooo' );
  writexy( LEFT, UP+17,  'o   o   o   o   o   o   o   o   o   o' );
  writexy( LEFT, UP+18,  'ooooooooooooooooooooooooooooooooooooo' );
  textcolor(COL2);
end;
   
 
procedure ViewHelp;

begin
                               
  writexy(2, 5,'x=  y=');
  writexy(2, 7,'Elección=');
  writexy(2,24,'F1-Ayuda F2-ahorrar F3-Carga F5- Resolver F8-Borrar flechas-Mover ESC-Finalizar');
  
 
  writexy(54,19,'creador jesus villarroel');
  writexy(54,20,'de 2023                   ');
  writexy(54,10,' *S*       * **   * **      ');
  writexy(54,11,' *U*      *    * *    *     ');
  writexy(54,12,' *D*      *     *     *     ');
  writexy(54,13,' *O*       *         *       ');
  writexy(54,14,' *K*        *      *         '); 
  writexy(54,15,' *U*         *   *           ');
  writexy(54,16,'               *             ')
    
  
end;
 
 
{ ver ayuda de sudoku }
procedure help;
begin
end;
 
 
{  mover a la posición y escribir el número}
{ escribe el número posible para esto }
procedure Kurzor(x,y,c:integer);
var xr,yr:integer;
    i:integer;
begin
  gotoxy(4,5); write(x);
  gotoxy(8,5); write(y);
 
  { ver elección }
  gotoxy(2,8);
  for i:=1 to 9 do
    if( s[x,y,i]=0 )then
       write(SPACE)
    else
       write(i);
 
  { calcular posicion real }
  xr:=LEFT + x*4 -2;
  yr:=UP + y*2 -1;

  gotoxy(xr,yr);
  textbackground(c);
 
  if( s[x,y,0]=0 )then
     write( SPACE )
  else
     write(s[x,y,0]);
 
  gotoxy(xr,yr);
end;
 
 
{área despejada  }
procedure Clear;
var xc,yc,i: integer;
begin
  for xc:=1 to 9 do
    for yc:=1 to 9 do
    begin
      for i:=0 to 9 do
         s[xc,yc,i]:=i;
 
      Kurzor(xc,yc,COLBG);
    end;
end;
 
 
{ Guardar en archivo }
procedure save;
var f: file of byte;
    xc,yc: integer;
begin
  Assign(f, DAT_FILE);
  ReWrite(f);
 
  for xc:=1 to 9 do
    for yc:=1 to 9 do
      Write(f, s[xc,yc,0]);
 
  Close(f);
end;
 
 
{ carga del archivo }
procedure Load;
var f: file of byte;
    xc,yc: integer;
begin
  Clear;
 
  {$I-}
  Assign(f, DAT_FILE);
  ReSet(f);
  {$I+}
 
  { si el archivo existe }
  if( IOResult=0 )then
  begin
    for xc:=1 to 9 do
      for yc:=1 to 9 do
      begin
        Read(f, s[xc,yc,0]);
        Kurzor(xc,yc,COLBG);
      end;
    Close(f);
  end;
end;
 
 
{ si solo es de un tipo, entonces es una resolución }
function GetSingle(x,y: integer):byte;
var i: integer;
    w: integer;
begin
  w:=0;
 
  for i:=1 to 9 do
    if( s[x,y,i]<>0 ) then
    begin
      if( w=0 )then w:=i
               else w:=-1;
    end;
 
  { resultado }
  if( w>0 )then GetSingle:=w
           else GetSingle:=0;
end;
 
 
{prueba cruzada de uso de algún número  }
function KrossTest(xc,yc:integer):byte;
var x,y: integer;
  xs,ys: integer;
      i: integer;
    poc: integer;
begin
  KrossTest:=0;
 
  for i:=1 to 9 do
    if( s[xc,yc,i]<>0 )then
    begin
      poc:=0;
 
      {de izquierda a derecha  }
      for x:=1 to 9 do
        if(( s[x,yc,i]=i ) and (s[x,yc,0]=0 ))then
           inc(poc);
 
      { single? }
      if( poc=1 )then
          KrossTest:=i;
 
      poc:=0;
      { arriba a abajo }
      for y:=1 to 9 do
        if(( s[xc,y,i]=i ) and (s[xc,y,0]=0 ))then
           inc(poc);
 
      { single }
      if( poc=1 )then
          KrossTest:=i;
 
      { en cuadrado }
      poc:=0;
      xs:=(xc-1) div 3;
      ys:=(yc-1) div 3;
 
      for x:=1 to 3 do
        for y:=1 to 3 do
          if(( s[3*xs+x,3*ys+y,i]=i ) and (s[3*xs+x,3*ys+y,0]=0 ))then
               inc(poc);
 
      { single }
      if( poc=1 )then
          KrossTest:=i;
    end;
end;
 
 
{hacer resolver  }
function Resolve:boolean;
var xc,yc: integer;
    xs,ys: integer;
    xi,yi: integer;
      c,i: integer;
begin
  Resolve:=false;
 
  for xc:=1 to 9 do
    for yc:=1 to 9 do
      if( s[xc,yc,0]=0 )then
       begin
         { resuelve esto }
         c:=s[xc,yc,0];
 
         { x-axis }
         for i:=1 to 9 do
           s[xc,yc, s[i,yc,0]]:=0;
 
         { y-axis }
         for i:=1 to 9 do
           s[xc,yc, s[xc,i,0]]:=0;
 
         { Hacer cuadrado }
         xs:=(xc-1) div 3;
         ys:=(yc-1) div 3;
 
         for xi:=1 to 3 do
           for yi:=1 to 3 do
             s[xc,yc, s[3*xs+xi,3*ys+yi,0]] := 0;
 
         { resolver de simplemente probar }
         s[xc,yc,0]:=GetSingle(xc,yc);
 
         { simplemente pruebe sin resultado pruebe la prueba cruzada }
         if( s[xc,yc,0]=0 )then
             s[xc,yc,0]:=KrossTest(xc,yc);
 
         Kurzor(xc,yc,COLBG);
 
         { si encontrar resolver }
         if( s[xc,yc,0]<>c )then
             Resolve:=true;
       end;
end;
 
 
BEGIN
  TextBackGround(COLBG);
  ClrScr;
 
  ViewSudoku;
  ViewHelp;
  Load;
 
  x:=1; y:=1;
 
  repeat
    { mover kurzor }
    Kurzor(x,y,COLBG);
 
    { mover kurzor }
    ch:=readkey;
 
    if( ch=#0 )then
        ch:=readkey;
 
    { F1, F2, F3, F5, F8 llaves }
    if( ch=#59 ) then Help;
    if( ch=#60 ) then Save;
    if( ch=#61 ) then Load;
    if( ch=#63 ) then while (Resolve) do;
    if( ch=#66 ) then Clear;
 
    { espacio como cero }
    if( ch=' ' )then ch:='0';
 
    { insertar número }
    if( ch in ['0'..'9']) then
      begin
        s[x,y,0]:=ord(ch) - ord('0');
        Kurzor(x,y,COLBG);
        x:=x+1;
      end;
 
    {flechas  }
    if( ch=#75 ) then x:=x-1;
    if( ch=#77 ) then x:=x+1;
    if( ch=#72 ) then y:=y-1;
    if( ch=#80 ) then y:=y+1;
 
    { inicio - fin }
    if( ch=#71 ) then x:=1;
    if( ch=#79 ) then x:=9;
 
    { inicio - fin }
    if( ch=#73 ) then y:=1;
    if( ch=#81 ) then y:=9;
 
    { comprobar la posición }
    if( x<1 ) then x:=9;
    if( x>9 ) then begin x:=1; y:=y+1; end;
    if( y<1 ) then y:=9;
    if( y>9 ) then y:=1;
 
  until (ch=#27);	{ ESC }
 
 writexy(6,3,'*GRACIAS POR JUGAR *');
   WRITEXY(6,4,' PRESIONE ENTER PARA CONTINUAR');
 
  { por seguridad }
  
  Save;
  
    
END.
