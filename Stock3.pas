program stock;

type
  tDes = integer;//id ����������
  tVol = integer;//��� �����
  
  tCell = ^cell;
  cell = record
    vol: tVol;
    des: tDes;
    next: tCell;
  end;//��� ������
  
  tList = ^clist;
  clist = record
    des: tDes;
    next: tList;
  end;//������ �����������

var
  pB_des: tList;//��������� �� ������ ��������
  pB_stock: tCell;//��������� �� ������� ������
  
  eexit: boolean;
  command: integer;





//�������� ������

procedure CreateCargo1(var pB: tCell);//�������� ������������ ��� ������ ������ � ����������� ���
begin
  new(pB);
  pB^.next := pB;
end;


procedure CreateList1(var pB: tList);//�������� ������������ ��� ������ ����������� � ����������� ���
begin
  new(pB);
  pB^.next := pB;
end;


procedure createStock(var pB: tCell);//������� �����
var
  maxVolStock: tVol;
begin
  maxVolStock := 100;//����������� ����������� ������
  CreateCargo1(pB);//������� ��������� �� ������ ����� ������
  pB^.vol := maxVolStock;//��������� ����������� ����������� ������ 
end;


procedure createDesList(var pB: tList);//������� ������ �����������
var
  maxVolDes: tDes;
begin
  maxVolDes := 10;//����������� ������������ ���������� �����������
  CreateList1(pB);//������� ��������� �� ������ �����������
  pB^.des := maxVolDes;//������������� ������������ ���������� �����������
end;

//����� �������� ������



//��������������� �������

function volDes(pB: tList): tDes;//������� �������� �������� ���������� �����������
var
  current: tList;
  sum: tDes;
begin
  current := pB^.next;
  sum := 0;
  while current <> pB do
  begin
    sum := sum + 1;
    current := current^.next;
  end;
  volDes := sum;
end;


function volStock(pB: tCell): tVol;//������� �������� ������� ������������ ������
var
  current: tCell;
  sum: tVol;
begin
  current := pB^.next;
  sum := 0;
  while current <> pB do
  begin
    sum := sum + current^.vol;
    current := current^.next;
  end;
  volStock := sum;
end;


function chekList(des: tDes; pB: tList): boolean;//�������� �� ������������� ���������� � ������
var
  chek: boolean;
  current: tList;
begin
  chek := false;
  current := pB^.next;
  while (current <> pB) and not chek do
  begin
    if des = current^.des then chek := true;
    current := current^.next;
  end;
  chekList := chek;
end;

//����� ��������������� �������


//���� � �����
procedure menu();
begin
  writeln('1. ������� ������ ������.');
  writeln('2. ���������(�����, ������ ��������).');
  writeln('3. ������� ����.');
  writeln('4. ������ ����.');
  writeln('5. ������� �����.');
  writeln('6. ������� ������ �����������.');
  writeln('9. ������� ����.');
  writeln('0. ��������� ������.');
end;


procedure statusStock(pB_stock: tCell; pB_des: tList);//������� ������ ������ � ������ �����������
var
  volS: tVol;
  volD: tDes;
begin
  volS := volStock(pB_stock);
  writeln('������� ������������� ������: ', volS);
  writeln('������������ ������������� ������: ', pB_stock^.vol);
  writeln();
  volD := volDes(pB_des);
  writeln('������� ���������� �����������: ', volD);
  writeln('������������ ���������� �����������: ', pB_des^.des);      
end;

procedure printStock(pB: tCell);//����� ����� ������
var
  current: tCell;
  count: integer;
begin
  if pB = pB^.next then writeln('����� ����.')
  else 
  begin
    current := pB^.next;
    count := 1;//������� ������
    while (current <> pB) do 
    begin
      writeln('���� �', count, '.    ���: ', current^.vol, '    ����������: ', current^.des);//����� �����
      count := count + 1;//���������� �������� ������
      current := current^.next;//������� � ���������� �����
    end;
  end;
end;

procedure printDes(pB: tList);//����� ������ �����������
var
  current: tList;
  count: integer;
begin
  if pB = pB^.next then writeln('������ ����������� ����.')
  else 
  begin
    current := pB^.next;
    count := 1;
    while current <> pB do
    begin
      writeln('���������� �', count, '.    Id: ', current^.des);//����� �����
      count := count + 1;//���������� ��������
      current := current^.next
    end;
  end;
end;

//����� ���� � ������



//��������� �����

function chekDes(des: tDes; pB: tList): boolean;//������� ������������ ����������
var
  chek: boolean;
  vol, maxVol: tDes;
begin
  chek := chekList(des, pB);
  if not chek then
  begin
    vol := volDes(pB);
    maxVol := pB^.des;
    if vol < maxVol then chek := true;
  end;
  chekDes := chek;
end;


function chekVol(vol: tVol; pB: tCell): boolean;//������� �������� ������ �� �����������
var
  chek: boolean;
  curVol, maxVol: tVol;
begin
  chek := false;
  maxVol := pB^.vol;
  curVol := volStock(pB);
  if vol + curVol <= maxVol then chek := true;
  chekVol := chek;
end;


procedure addStock(des: tDes; vol: tVol; var pB: tCell);//��������� ���������� � ����� ������ ����� ������ ������
var
  newCell: tCell;
  maxVol: tVol;
begin
  new(newCell);//������� ����� ������
  maxVol := pB^.vol;  
  pB^.vol := vol;//��������� ���
  pB^.des := des;//��������� ����������
  newCell^.next := pB^.next;//�������� ������ �� ��������� � ����� ������������
  pB^.next := newCell;//���������� ������ ������������ � ������
  pB := newCell;//��������� ������������
  pB^.vol := maxVol;
end;


procedure addDes(des: tDes; var pB: tList);//��������� ���������� � ����� ������ ������ ����������
var
  newDes: tList;
  maxDes: tDes;
begin
  new(newDes);//������� ����� ������
  maxDes := pB^.des;  
  pB^.des := des;//��������� ����������
  newDes^.next := pB^.next;//�������� ������ �� ��������� � ����� ������������
  pB^.next := newDes;//���������� ������ ������������ � ������
  pB := newDes;//��������� ������������
  pB^.des := maxDes;
end;


procedure updateDes(des: tDes; var pB: tList);//���������� ������ �����������
var
  chek: boolean;
begin
  chek := chekList(des, pB);
  if not chek then
    addDes(des, pB);
end;

procedure changeCargo(var vol: tVol; volS, maxVolS: tVol);//��������� ���� �����
begin
  vol := maxVolS - volS;
end;

procedure importCargo(var pB_stock: tCell; var pB_des: tList);//��������� �����
var
  vol: tVol;
  des: tDes;
  chek: boolean;
  volS: tVol;
  maxVolS: tVol;
begin
  write('������� ��� �����: ');
  readln(vol);
  write('������� ����������: ');
  readln(des);
  chek := chekDes(des, pB_des);//�������� �����������
  if chek then 
  begin
    chek := chekVol(vol, pB_stock);//�������� ������
    volS := volStock(pB_stock);
    maxVolS := pB_stock^.vol;
    if (not chek) and (volS <> maxVolS) then 
    begin
      changeCargo(vol, volS, maxVolS); 
      chek := true;
      writeln('���� �������.');
    end;
  end;
  if chek then
  begin
    addStock(des, vol, pB_stock);//���������� ������� ������
    updateDes(des, pB_des);//���������� ������ �����������
    writeln('���� ������.');
  end
  else
    writeln('���� �� ������.');
end;

//����� ��������� �����



//������� �����

procedure loadCargo(var volShip: tVol; var curCell: tCell);//��������� �������� �����
begin
  if volShip >= curCell^.vol then //���� ���������� ������� ������ ��� ����� ���� �����
  begin
    volShip := volShip - curCell^.vol;//��������� �� �������
    curCell^.vol := 0;//���������� ������ ������
  end
  else
  begin
    curCell^.vol := curCell^.vol - volShip;//� ������ ��������� �������� ����
    volShip := 0;//��������� ��������� �������
  end;
end;


procedure delCell(var predCell: tCell);//�������� ������� ������ ������
var
  del: tCell;
begin
  del := predCell^.next;
  predCell^.next := del^.next;
  Dispose(del);
end;


function chekDesInStock(des: tDes; pB: tCell): boolean;//������� �������� ���������� � ������ �����
var
  chek: boolean;
  current: tCell;
begin
  chek := false;
  current := pB^.next;
  while (current <> pB) and not chek do
  begin
    if des = current^.des then chek := true;
    current := current^.next;
  end;
  chekDesInStock := chek;
end;


procedure delDes(des: tDes; var pB: tList);//������� �������� ���������� �� ID
var
  predDes: tList;
  del: tList;
begin
  predDes := pB;
  while predDes^.next^.des <> des do
    predDes := predDes^.next;
  del := predDes^.next;
  predDes^.next := del^.next;
  Dispose(del);
end;


procedure exportCargo(var pB_stock: tCell; var pB_des: tList);//������ �����
var
  des: tDes;
  volShip: tVol;
  chek: boolean;
  curCell: tCell;
  predCell: tCell;
  checkDes: boolean;
begin
  write('������� ����������: ');
  readln(des);
  write('������� ���� �����������: ');
  readln(volShip);
  chek := chekList(des, pB_des);
  if chek then
  begin
    curCell := pB_stock^.next;
    predCell := pB_stock;
    while (volShip <> 0) and (curCell <> pB_stock) do
    begin
      if (des = curCell^.des) then
      begin
        loadCargo(volShip, curCell);
        if curCell^.vol = 0 then 
        begin
          delCell(predCell);
        end;
      end;
      predCell := curCell;
      curCell := curCell^.next;
    end;
    checkDes := chekDesInStock(des, pB_stock);
    if not checkDes then delDes(des, pB_des);
    writeln('���� ���������.');
  end
  else writeln('���������� �� ������.');
end;

//����� �������� �����



procedure setMenu();//���� ��������
begin
  writeln('1. �������� ������������ ����������� ������.');
  writeln('2. �������� ������������ ���������� �����������.');
  writeln('0. ����� �� ���� ��������.');
end;


procedure changeMaxVolStock(var pB: tCell);//��������� ��������� ����������� ������
begin
  write('������� ����������� ������: ');
  readln(pB^.vol);
end;


procedure changeMaxVolDes(var pB: tList);//��������� ��������� ������������� �������� �����������
begin
  write('������� ����������� ��������� �����������: ');
  readln(pB^.des);
end;

procedure setting(var pB_stock: tCell; var pB_des: tList);//����������
var
  operation: integer;
  eexit: boolean;
begin
  eexit := false;
  if (pB_stock <> pB_stock^.next) or (pB_des <> pB_des^.next) then
  begin
    writeln('��������� ����������.');
    eexit := true;
  end
  else
  begin
    setMenu();
    while not eexit do
    begin
      writeln();
      write('������� �������� ��������...');
      readln(operation);
      case operation of
        1: changeMaxVolStock(pB_stock);
        2: changeMaxVolDes(pB_des);
        0: 
          begin
            eexit := true;
            writeln('����� �� ��������.');
            writeln();
            menu();
          end;
      end;
    end;
  end;
end;





begin
  createStock(pB_stock);//������� �����
  createDesList(pB_des);//������� ������ �����������
  eexit := false;
  menu();//������� ����
  writeln();
  while not eexit do//���� �� ��������� ������
  begin
    writeln();
    write('������� �������...');
    readln(command);//��������� �������
    writeln();
    case command of//������������ �������
      1: statusStock(pB_stock, pB_des);//������� ������ ������
      2: setting(pB_stock, pB_des);//��������� ������������ ��������
      3: importCargo(pB_stock, pB_des);//��������� �����
      4: exportCargo(pB_stock, pB_des);
      5: printStock(pB_stock);
      6: printDes(pB_des);
      9: menu();
      0: eexit := true;
    else writeln('����� ������� �� ����������.');
    end;
  end;
end.