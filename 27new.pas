program n27;

const
  maxSize = 20;//максимальная длина слова

type
  tInfo = string[maxSize];//тип слова
  
  tPoint = ^point;
  point = record
    info: tInfo;
    next: tPoint;
  end;//тип элемента очереди или списка
  
  tLetter = record
    info: string;
    first: tPoint;
    last: tPoint;
  end;//тип буквы
  
  tAlphabet = array of tLetter;//тип алфавита

var
  qBegining, qLast: tPoint;//начало списка слов
  OL: tAlphabet;//алфавит
  quantity: integer;//количество элементов в алфавите


//создание алфавита

procedure createQueue(var queueFirst: tPoint; var queueLast: tPoint);
var
  newPoint: tPoint;
begin
  new(newPoint);
  newPoint^.next := nil;
  queueFirst := newPoint;
  queueLast := newPoint;
end;

function createLetter(letter: char): tLetter;
var
  newLetter: tLetter;
begin
  newLetter.info := letter;
  result := newLetter;
end;

procedure inputAlphabet(var quantity: integer; var OL: tAlphabet);//ввод алфавита
var
  count: integer;
  letter: char;
begin
  write('Введите количество букв в алфавите: ');
  readln(quantity);
  SetLength(OL, quantity + 1);
  writeln('Введите алфавит:');
  for count := 0 to quantity do 
  begin
    if count <> 0 then readln(letter)//ввод буквы
    else letter := '*';
    OL[count] := createLetter(letter);//создает букву
  end;
end;

//конец создания алфавита

procedure addQueue(eword: tInfo; var first: tPoint; var last: tPoint);//добавление в очередь
var
  newPoint: tPoint;
begin
  new(newPoint);
  newPoint^.info := eword;
  if first = nil then begin
    first := newPoint;
    last := newPoint;
  end
  else begin
    last^.next := newPoint;
    last := newPoint;
  end;
end;


//ввод списка слов

procedure addPoint(eword: tInfo);//добавление в список
var
  newPoint: tPoint;
begin
  new(newPoint);
  newPoint^.info := eword;
  if qBegining = nil then begin
    qBegining := newPoint;
    qLast := newPoint;
  end
  else begin
    qLast^.next := newPoint;
    qLast := newPoint;
  end;
end;

procedure inputList ();//ввод списка
var
  count, quantityWord: integer;
  eword: tInfo;
begin
  write('Введите количество слов: ');
  readln(quantityWord);
  writeln('Введите список слов:');
  for count := 1 to quantityWord do 
  begin
    readln(eword);
    addPoint(eword);
  end;
end;

procedure outputList();//вывод списка
var
  currentPoint: tPoint;
begin
  writeln('Вывод:');
  currentPoint := qBegining;
  while currentPoint <> nil do
  begin
    writeln(currentPoint^.info);
    currentPoint := currentPoint^.next;
  end;
end;

//конец ввода списка слов

//начало сортировки

procedure obnul(qantity: integer; var OL: tAlphabet);//очистка очередей алфавита
var
  count: integer;
begin
  for count := 0 to quantity do 
  begin
    OL[count].first := nil;
    OL[count].last := nil;
  end;
end;

procedure delete();
var garbage, current: tPoint;
begin
  current := qBegining;
  while current<>nil do begin
    garbage := current;
    current:=current^.next;
    Dispose(garbage);
  end;
end;

procedure union(quantity: integer; var OL: tAlphabet; var first: boolean);//объединение очередей в список
var
  count: integer;
begin
  delete();
  for count := 0 to quantity do
  begin
    if first and (OL[count].last <> nil) then begin
      qBegining := OL[count].first;
      qLast := OL[count].last;
      first := false;
    end
    else begin
      if OL[count].last <> nil then begin
        qLast^.next := OL[count].first;
        qLast := OL[count].last;
      end;
    end;
  end;
  obnul(quantity, OL);//обнулуние очередей алфавита
end;


procedure sorting(quantity: integer; var OL: tAlphabet);//сортировка списка слов
var
  i, count: integer;
  currentWord: tPoint;
  first, isInput: boolean;
begin
  for i := maxSize downto 1 do
  begin
    first := true;
    currentWord := qBegining;
    while currentWord <> nil do 
    begin
      isInput := false;
      for count := 1 to quantity do
      begin
        if OL[count].info = currentWord^.info[i] then begin
          addQueue(currentWord^.info, OL[count].first, OL[count].last);
          isInput := true;
        end;
      end;
      if not isInput then
        addQueue(currentWord^.info, OL[0].first, OL[0].last);
      currentWord := currentWord^.next;
    end;
    union(quantity, OL, first);
  end;
end;

//конец сортировки


begin
  inputAlphabet(quantity, OL);//ввод алфавита
  inputList();//ввод списка слов
  sorting(quantity, OL);//сортировка слов
  outputList();
end.