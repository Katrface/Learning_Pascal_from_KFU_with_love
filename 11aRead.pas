program n_11_a;

type
  tInfo = integer;
  tElement = ^element;
  element = record
    info: tInfo;
    next: tElement;
  end;//объявления списка
//*element <=> ссылка
var
  qBegining, qLast, rBegining, rLast, pElement: tElement;
  
  status: boolean;

procedure add_to_the_begining(var firstElement: tElement);//процедура добавления в начало(голову) списка
var
  newElement: tElement;
begin
  new(newElement);
  read(newElement^.info);
  newElement^.next := firstElement;
  firstElement := newElement;
end;

procedure add_to_the_end(var lastElement: tElement);//процедура добавления в конец списка
var
  newElement: tElement;
begin
  new(newElement);
  readln(newElement^.info);
  lastElement^.next := newElement;
  newElement^.next := nil;
  lastElement := newElement;
  
end;

procedure createList(var firstElement, lastElement: tElement);//процедура ввода списка
var
  amount, count: integer;
begin
  write('Введите кол-во узлов: ');
  readln(amount);
  writeln('Введите список: ');
  if amount >= 1 then 
  begin
    add_to_the_begining(firstElement);
    lastElement := firstElement;
  end;//создание и обозначение "головы" списка
  for count := 2 to amount do
    add_to_the_end(lastElement);//ввод последующих элементов списка
end;

function equalsList(rBegining, cBegining{элемент который совпал в верхнем условии}: tElement): boolean;//предикат проверки на равенство списков
var
  R_current_Element, c_current_Element: tElement;
begin
  //А квантор
  result := true;//подготовка условия для А квантора
  R_current_Element := rBegining;//установка на "голову" для искомого списка
  c_current_Element := cBegining;//подготовка вспомогательного указателя двигающегося по базавому списку начиная с определенного узла
  while (R_current_Element <> nil) and result do//пока не кончится искомый список или найдется противоречее
  begin
    if R_current_Element^.info <> c_current_Element^.info then//проверка на противоречее
      result := false;
    R_current_Element := R_current_Element^.next;//переход к следующему элементу искомого списка
    c_current_Element := c_current_Element^.next;//переход к следующему элементу базового списка
  end;
end;

function isSublist(qBegining, rBegining: tElement): boolean;//функция проверки на существование данного подсписка в базовом списке
var
  currentElement: tElement;
begin
  //Е квантор
  result := false;//подготовка условия
  currentElement := qBegining;//установление на "голову" базового списка
  while not result and (currentElement <> nil) do 
  begin//пока не найдется подсписок или не закончится базовый список
    if currentElement^.info = rBegining^.info then//проверка равенства с первым елементом
      result := equalsList(rBegining, currentElement);//проверка равенства последующего списка с подсписком
    currentElement := currentElement^.next;//переход к следующему элементу базового списка
  end;
end;




begin
  writeln('Список Q(базовый список):');
  createList(qBegining, qLast);//ввод базового списка
  writeln('Список R(предпалогаемый подсписок):');
  createList(rBegining, rLast);//ввод искомого подсписка
  status := isSublist(qBegining, rBegining);//функция проверки на существование данного подсписка в базовом списке
  if status then
    writeln('Список R является подсписком Q.')
  else
    writeln('Список R не является подсписком Q.');
  writeln(status);//вывод результата
end.