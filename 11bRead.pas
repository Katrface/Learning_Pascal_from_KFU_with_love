program n_11_b;

type
  tInfo = integer;
  tElement = ^element;
  element = record
    info: tInfo;
    next: tElement;
  end;//���������� ������
//*element <=> ������
var
  qBegining, qLast, rBegining, rLast, pElement, pBegining, pLast, beginingSublist, postSublist: tElement;
  
  status: boolean;

procedure add_to_the_begining(var firstElement: tElement);//��������� ���������� � ������(������) ������
var
  newElement: tElement;
begin
  new(newElement);
  read(newElement^.info);
  newElement^.next := firstElement;
  firstElement := newElement;
end;

procedure add_to_the_end(var lastElement: tElement);//��������� ���������� � ����� ������
var
  newElement: tElement;
begin
  new(newElement);
  readln(newElement^.info);
  lastElement^.next := newElement;
  newElement^.next := nil;
  lastElement := newElement;
  
end;

procedure createList(var firstElement, lastElement: tElement);//��������� ����� ������
var
  amount, count: integer;
begin
  write('������� ���-�� �����: ');
  readln(amount);
  writeln('������� ������: ');
  if amount >= 1 then 
  begin
    add_to_the_begining(firstElement);
    lastElement := firstElement;
  end;//�������� � ����������� "������" ������
  for count := 2 to amount do
    add_to_the_end(lastElement);//���� ����������� ��������� ������
end;

procedure equalsList(rBegining, cBegining{������� ������� ������ � ������� �������} : tElement; var postSublist: tElement; var status: boolean);//�������� �������� �� ��������� �������
var
  R_current_Element, c_current_Element: tElement;
begin
  //� �������
  status := true;//���������� ������� ��� � ��������
  R_current_Element := rBegining;//��������� �� "������" ��� �������� ������
  c_current_Element := cBegining;//���������� ���������������� ��������� ������������ �� �������� ������ ������� � ������������� ����
  while (R_current_Element <> nil) and status do//���� �� �������� ������� ������ ��� �������� ������������
  begin
    if R_current_Element^.info <> c_current_Element^.info then//�������� �� ������������
      status := false;
    R_current_Element := R_current_Element^.next;//������� � ���������� �������� �������� ������
    c_current_Element := c_current_Element^.next;//������� � ���������� �������� �������� ������
  end;
  {*} postSublist := c_current_Element;//�������� ������ �������� �������� ����� ����������� ���������
end;

procedure isSublist(qBegining{q<=>p}, rBegining{r<=>q} : tElement; var beginingSublist: tElement; var postSublist: tElement; var status: boolean);//������� �������� �� ������������� ������� ��������� � ������� ������
var
  currentElement: tElement;
begin
  //� �������
  status := false;//���������� �������
  currentElement := qBegining;//������������ �� "������" �������� ������
  while not status and (currentElement <> nil) do 
  begin//���� �� �������� ��������� ��� �� ���������� ������� ������
    if currentElement^.info = rBegining^.info then//�������� ��������� � ������ ���������
      equalsList(rBegining, currentElement, postSublist, status);//�������� ��������� ������������ ������ � ����������
    {*} if status then beginingSublist := currentElement;//�������� ������ �� ������ ������� ����������� ���������
    currentElement := currentElement^.next;//������� � ���������� �������� �������� ������
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
  writeln('������ P(������� ������):');
  createList(pBegining, pLast);//���� �������� ������
  writeln('������ Q(���������� ���������):');
  createList(qBegining, qLast);//���� �������� ���������
  //prefSublist:=pBegining;
  isSublist(pBegining, qBegining, beginingSublist, postSublist, status);//������� �������� �� ������������� ������� ��������� � ������� ������
  if status then begin
    writeln('������ R(���������� ���������):');
    createList(rBegining, rLast);//���� ����������� ���������
    
    rLast^.next := postSublist;//���������� ����� ������������ ��������� �� ��������� ��������� ����� �������� ���������
    beginingSublist^.info := rBegining^.info;//->
    beginingSublist^.next := rBegining^.next;//������� �������� ������� �������� ������������ ��������� � ������ ������� ����������(�����������) ��������� {������� �������� 1-��� ��������, ��� ������ �� ���� �������}
    
    printList(pBegining);//����� �������� ������ � �������
  end
  else
    writeln('�������� ��������� �� ����������.');
end.