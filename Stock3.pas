program stock;

type
  tDes = integer;//id получателя
  tVol = integer;//вес груза
  
  tCell = ^cell;
  cell = record
    vol: tVol;
    des: tDes;
    next: tCell;
  end;//тип склада
  
  tList = ^clist;
  clist = record
    des: tDes;
    next: tList;
  end;//список получателей

var
  pB_des: tList;//указатель на список клиентов
  pB_stock: tCell;//указатель на очередь грузов
  
  eexit: boolean;
  command: integer;





//создание склада

procedure CreateCargo1(var pB: tCell);//создание ограничителя для списка грузов и зацикливает его
begin
  new(pB);
  pB^.next := pB;
end;


procedure CreateList1(var pB: tList);//создание ограничителя для списка получателей и зацикливает его
begin
  new(pB);
  pB^.next := pB;
end;


procedure createStock(var pB: tCell);//создает склад
var
  maxVolStock: tVol;
begin
  maxVolStock := 100;//стандартная вместимость склада
  CreateCargo1(pB);//создает указатель на список ячеек склада
  pB^.vol := maxVolStock;//установка стандартной вместимости склада 
end;


procedure createDesList(var pB: tList);//создает список получателей
var
  maxVolDes: tDes;
begin
  maxVolDes := 10;//стандартное максимальное количество получателей
  CreateList1(pB);//создает указатель на список получателей
  pB^.des := maxVolDes;//устанавливает максимальное количество получателей
end;

//конец создания склада



//вспомогательные функции

function volDes(pB: tList): tDes;//функция подсчета текущего количества получателей
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


function volStock(pB: tCell): tVol;//функция подсчета текущей заполнености склада
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


function chekList(des: tDes; pB: tList): boolean;//проверка на существование получателя в списке
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

//конец вспомогательных функций


//меню и вывод
procedure menu();
begin
  writeln('1. Вывести статус склада.');
  writeln('2. Настройки(Склад, список клиентов).');
  writeln('3. Принять груз.');
  writeln('4. Выдать груз.');
  writeln('5. Вывести склад.');
  writeln('6. Вывести список получателей.');
  writeln('9. Вывести меню.');
  writeln('0. Закончить работу.');
end;


procedure statusStock(pB_stock: tCell; pB_des: tList);//выводит статус склада и списка получателей
var
  volS: tVol;
  volD: tDes;
begin
  volS := volStock(pB_stock);
  writeln('Текущая загруженность склада: ', volS);
  writeln('Максимальная загруженность склада: ', pB_stock^.vol);
  writeln();
  volD := volDes(pB_des);
  writeln('Текущее количество получателей: ', volD);
  writeln('Максимальное количество получателей: ', pB_des^.des);      
end;

procedure printStock(pB: tCell);//вывод ячеек склада
var
  current: tCell;
  count: integer;
begin
  if pB = pB^.next then writeln('Склад пуст.')
  else 
  begin
    current := pB^.next;
    count := 1;//счетчик грузов
    while (current <> pB) do 
    begin
      writeln('Груз №', count, '.    Вес: ', current^.vol, '    Получатель: ', current^.des);//вывод груза
      count := count + 1;//добавление счетчика грузов
      current := current^.next;//переход к следующему грузу
    end;
  end;
end;

procedure printDes(pB: tList);//вывод списка получателей
var
  current: tList;
  count: integer;
begin
  if pB = pB^.next then writeln('Список получателей пуст.')
  else 
  begin
    current := pB^.next;
    count := 1;
    while current <> pB do
    begin
      writeln('Получатель №', count, '.    Id: ', current^.des);//вывод груза
      count := count + 1;//добавление счетчика
      current := current^.next
    end;
  end;
end;

//конец меню и вывода



//получение груза

function chekDes(des: tDes; pB: tList): boolean;//функция подверждения получателя
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


function chekVol(vol: tVol; pB: tCell): boolean;//функция проверки склада на вместимость
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


procedure addStock(des: tDes; vol: tVol; var pB: tCell);//процедура добавления в конец списка новой ячейки склада
var
  newCell: tCell;
  maxVol: tVol;
begin
  new(newCell);//создаем новую ячейку
  maxVol := pB^.vol;  
  pB^.vol := vol;//заполняем вес
  pB^.des := des;//заполняем получателя
  newCell^.next := pB^.next;//копируем ссылку на следующий в новый ограничитель
  pB^.next := newCell;//подцепляем старый ограничитель к новому
  pB := newCell;//обновляем ограничитель
  pB^.vol := maxVol;
end;


procedure addDes(des: tDes; var pB: tList);//процедура добавления в конец списка нового получателя
var
  newDes: tList;
  maxDes: tDes;
begin
  new(newDes);//создаем новую ячейку
  maxDes := pB^.des;  
  pB^.des := des;//заполняем получателя
  newDes^.next := pB^.next;//копируем ссылку на следующий в новый ограничитель
  pB^.next := newDes;//подцепляем старый ограничитель к новому
  pB := newDes;//обновляем ограничитель
  pB^.des := maxDes;
end;


procedure updateDes(des: tDes; var pB: tList);//обновление списка получателей
var
  chek: boolean;
begin
  chek := chekList(des, pB);
  if not chek then
    addDes(des, pB);
end;

procedure changeCargo(var vol: tVol; volS, maxVolS: tVol);//изменение веса груза
begin
  vol := maxVolS - volS;
end;

procedure importCargo(var pB_stock: tCell; var pB_des: tList);//получение груза
var
  vol: tVol;
  des: tDes;
  chek: boolean;
  volS: tVol;
  maxVolS: tVol;
begin
  write('Введите вес груза: ');
  readln(vol);
  write('Введите получателя: ');
  readln(des);
  chek := chekDes(des, pB_des);//проверка получателей
  if chek then 
  begin
    chek := chekVol(vol, pB_stock);//проверка склада
    volS := volStock(pB_stock);
    maxVolS := pB_stock^.vol;
    if (not chek) and (volS <> maxVolS) then 
    begin
      changeCargo(vol, volS, maxVolS); 
      chek := true;
      writeln('Груз изменен.');
    end;
  end;
  if chek then
  begin
    addStock(des, vol, pB_stock);//обновление статуса склада
    updateDes(des, pB_des);//обновление списка получателей
    writeln('Груз принят.');
  end
  else
    writeln('Груз не принят.');
end;

//конец получения груза



//экспорт груза

procedure loadCargo(var volShip: tVol; var curCell: tCell);//процедура погрузки груза
begin
  if volShip >= curCell^.vol then //если вместимоль коробля больше или равна весу груза
  begin
    volShip := volShip - curCell^.vol;//загружаем на корабль
    curCell^.vol := 0;//опустошаем ячейку склада
  end
  else
  begin
    curCell^.vol := curCell^.vol - volShip;//в ячейке оставляем излишний груз
    volShip := 0;//полностью заполняем корабль
  end;
end;


procedure delCell(var predCell: tCell);//удаление текушей ячейки склада
var
  del: tCell;
begin
  del := predCell^.next;
  predCell^.next := del^.next;
  Dispose(del);
end;


function chekDesInStock(des: tDes; pB: tCell): boolean;//функция проверки получателя в списке ячеек
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


procedure delDes(des: tDes; var pB: tList);//функция удаления получателя по ID
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


procedure exportCargo(var pB_stock: tCell; var pB_des: tList);//выдача груза
var
  des: tDes;
  volShip: tVol;
  chek: boolean;
  curCell: tCell;
  predCell: tCell;
  checkDes: boolean;
begin
  write('Введите получателя: ');
  readln(des);
  write('Введите свою вместимость: ');
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
    writeln('Груз отправлен.');
  end
  else writeln('Получатель не найден.');
end;

//конец экспорта груза



procedure setMenu();//меню настроек
begin
  writeln('1. Изменить максимальную вместимость склада.');
  writeln('2. Изменить максимальное количество получателей.');
  writeln('0. Выход из меню Настроек.');
end;


procedure changeMaxVolStock(var pB: tCell);//процедура изменения вместимости склада
begin
  write('Введите вместимость склада: ');
  readln(pB^.vol);
end;


procedure changeMaxVolDes(var pB: tList);//процедура изменения максимального значения получателей
begin
  write('Введите максимальне колиество получателей: ');
  readln(pB^.des);
end;

procedure setting(var pB_stock: tCell; var pB_des: tList);//найстройки
var
  operation: integer;
  eexit: boolean;
begin
  eexit := false;
  if (pB_stock <> pB_stock^.next) or (pB_des <> pB_des^.next) then
  begin
    writeln('Настройки недоступны.');
    eexit := true;
  end
  else
  begin
    setMenu();
    while not eexit do
    begin
      writeln();
      write('Введите операцию настроек...');
      readln(operation);
      case operation of
        1: changeMaxVolStock(pB_stock);
        2: changeMaxVolDes(pB_des);
        0: 
          begin
            eexit := true;
            writeln('Выход из настроек.');
            writeln();
            menu();
          end;
      end;
    end;
  end;
end;





begin
  createStock(pB_stock);//создаем склад
  createDesList(pB_des);//создаем список получателей
  eexit := false;
  menu();//выводим меню
  writeln();
  while not eexit do//пока не закончили работу
  begin
    writeln();
    write('Введите команду...');
    readln(command);//считываем команду
    writeln();
    case command of//обрабатываем команду
      1: statusStock(pB_stock, pB_des);//выводит статус склада
      2: setting(pB_stock, pB_des);//настройка максимальных значений
      3: importCargo(pB_stock, pB_des);//получение груза
      4: exportCargo(pB_stock, pB_des);
      5: printStock(pB_stock);
      6: printDes(pB_des);
      9: menu();
      0: eexit := true;
    else writeln('Такой команды не существует.');
    end;
  end;
end.