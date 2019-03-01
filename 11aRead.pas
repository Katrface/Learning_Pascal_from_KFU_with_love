program n_11_a;

type
  tInfo = integer;
  tElement = ^element;
  element = record
    info: tInfo;
    next: tElement;
  end;//���������� ������
//*element <=> ������
var
  qBegining, qLast, rBegining, rLast, pElement: tElement;
  
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

function equalsList(rBegining, cBegining{������� ������� ������ � ������� �������}: tElement): boolean;//�������� �������� �� ��������� �������
var
  R_current_Element, c_current_Element: tElement;
begin
  //� �������
  result := true;//���������� ������� ��� � ��������
  R_current_Element := rBegining;//��������� �� "������" ��� �������� ������
  c_current_Element := cBegining;//���������� ���������������� ��������� ������������ �� �������� ������ ������� � ������������� ����
  while (R_current_Element <> nil) and result do//���� �� �������� ������� ������ ��� �������� ������������
  begin
    if R_current_Element^.info <> c_current_Element^.info then//�������� �� ������������
      result := false;
    R_current_Element := R_current_Element^.next;//������� � ���������� �������� �������� ������
    c_current_Element := c_current_Element^.next;//������� � ���������� �������� �������� ������
  end;
end;

function isSublist(qBegining, rBegining: tElement): boolean;//������� �������� �� ������������� ������� ��������� � ������� ������
var
  currentElement: tElement;
begin
  //� �������
  result := false;//���������� �������
  currentElement := qBegining;//������������ �� "������" �������� ������
  while not result and (currentElement <> nil) do 
  begin//���� �� �������� ��������� ��� �� ���������� ������� ������
    if currentElement^.info = rBegining^.info then//�������� ��������� � ������ ���������
      result := equalsList(rBegining, currentElement);//�������� ��������� ������������ ������ � ����������
    currentElement := currentElement^.next;//������� � ���������� �������� �������� ������
  end;
end;




begin
  writeln('������ Q(������� ������):');
  createList(qBegining, qLast);//���� �������� ������
  writeln('������ R(�������������� ���������):');
  createList(rBegining, rLast);//���� �������� ���������
  status := isSublist(qBegining, rBegining);//������� �������� �� ������������� ������� ��������� � ������� ������
  if status then
    writeln('������ R �������� ���������� Q.')
  else
    writeln('������ R �� �������� ���������� Q.');
  writeln(status);//����� ����������
end.