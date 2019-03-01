program n_11_b;

type
  tInfo = integer;
  tElement = ^element;
  element = record
    info: tInfo;
    next: tElement;
  end;//объявления списка
//*element <=> ссылка
var
  qBegining, qLast, rBegining, rLast, pElement, pBegining, pLast, beginingSublist, postSublist: tElement;
  
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

procedure equalsList(rBegining, cBegining{элемент который совпал в верхнем условии} : tElement; var postSublist: tElement; var status: boolean);//предикат проверки на равенство списков
var
  R_current_Element, c_current_Element: tElement;
begin
  //А квантор
  status := true;//подготовка условия для А квантора
  R_current_Element := rBegining;//установка на "голову" для искомого списка
  c_current_Element := cBegining;//подготовка вспомогательного указателя двигающегося по базавому списку начиная с определенного узла
  while (R_current_Element <> nil) and status do//пока не кончится искомый список или найдется противоречее
  begin
    if R_current_Element^.info <> c_current_Element^.info then//проверка на противоречее
      status := false;
    R_current_Element := R_current_Element^.next;//переход к следующему элементу искомого списка
    c_current_Element := c_current_Element^.next;//переход к следующему элементу базового списка
  end;
  {*} postSublist := c_current_Element;//фиксация ссылки элемента стоящего после заменяемого подсписка
end;

procedure isSublist(qBegining{q<=>p}, rBegining{r<=>q} : tElement; var beginingSublist: tElement; var postSublist: tElement; var status: boolean);//функция проверки на существование данного подсписка в базовом списке
var
  currentElement: tElement;
begin
  //Е квантор
  status := false;//подготовка условия
  currentElement := qBegining;//установление на "голову" базового списка
  while not status and (currentElement <> nil) do 
  begin//пока не найдется подсписок или не закончится базовый список
    if currentElement^.info = rBegining^.info then//проверка равенства с первым елементом
      equalsList(rBegining, currentElement, postSublist, status);//проверка равенства последующего списка с подсписком
    {*} if status then beginingSublist := currentElement;//фиксация ссылка на первый элемент заменяемого подсписка
    currentElement := currentElement^.next;//переход к следующему элементу базового списка
  end;
end;

procedure printList(firstElement: tElement);
var
  currentElement: tElement;
begin
  currentElement := firstElement;
  while currentElement <> nil do 
  begin
    write(currentElement^.info, ' ');
    currentElement := currentElement^.next;
  end;
end;

begin
  writeln('Список P(базовый список):');
  createList(pBegining, pLast);//ввод базового списка
  writeln('Список Q(заменяемый подсписок):');
  createList(qBegining, qLast);//ввод искомого подсписка
  //prefSublist:=pBegining;
  isSublist(pBegining, qBegining, beginingSublist, postSublist, status);//функция проверки на существование данного подсписка в базовом списке
  if status then begin
    writeln('Список R(замещающий подсписок):');
    createList(rBegining, rLast);//ввод замещающего подсписка
    
    rLast^.next := postSublist;//связывание конца вставляемого подсписка со следующим елементом после искомого подсписка
    beginingSublist^.info := rBegining^.info;//->
    beginingSublist^.next := rBegining^.next;//перенос значений первого элемента вставляемого подсписка в первый элемент удаляемого(заменяемого) подсписка {решение проблемы 1-ого элемента, при замене на один элемент}
    
    printList(pBegining);//вывод базового списка с заменой
  end
  else
    writeln('Искомого подсписка не существует.');
end.