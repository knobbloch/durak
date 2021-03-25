unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unit3, ExtCtrls ;

type
Tcard = class//1 - красные сердечки, 2 - черные сердечки, 3 - красная оставшаяся фигура, 4 - черная оставшаяся фигура
private
public
  number : integer; //чем больше тем круче 13 - туз, 12 - король, 11- дама, 10 - валет,  9 - 10 , 8 - 9, 7 - 8, 6 - 7, 5 - 6, 4 - 5, 3 - 4, 2 - 3, 1 - 2 ой упс как то криво ахах
  suit : integer;
  iscardcovered : boolean; //это для проверки занята ли карта на столе
  //image : TImage;
  constructor create (numberofcard, suitofcard : integer);
end;

Tguy = class
private
public
  isplaying : boolean; //закончил ли игрок играть
  numberplace : integer;
  //cards: array[1..6] of Tcard;
  cards : TList;
  //condition : integer;
  condition : integer;//condition перенесен
  b5 : integer;  //для локальных настроек кнопок
  b4 : integer;   //значение 1 - включить, 0 - выключить, другие значения - ничего не делать, после каждого обновления кнопок значение меняется на -1
  b3 : integer;
  b6: integer;
  b7: integer;
  b8:  integer;
  constructor create(numberplaceforguy : integer);
  destructor Destroy;
end;

Tplaytable = class
public
  leaderindex : integer;// чел который подкидывает ((1..7) mod 8)
  activeindex : integer;
  supercard : integer;
  countofplayers : integer;
  guys : TList; // игрок всегда нулевой гай!!
  card6 : TList;//вот они те самые 6 карт из за которых замес
  arrayofallcards : TList;//колода карт
  covercard6 : TList;
  condition : integer; //0 - решить, 1- крыть, 2 - ход, 3 - подкидывать
  //property playerCardsCount: Integer read GetPlayerCardsCount;
  //property playerCards[index:Integer]: Tcard read GetPlayerCard;
  constructor create(players:integer);
  destructor destroy;
  procedure take;
  procedure tableClean;
  function canTransfer(card:Tcard): boolean;
  procedure switchdefender (card:Tcard);
  function GetPlayerCardsCount(indexofplayer:Integer): Integer;
  function GetPlayerCard(indexofplayer, indexofcard:Integer): Tcard;
  function nextleaderindex : integer;
  procedure covercards (CardFromInventory, OnTableCard : Tcard);
  function canplayergive (CardFromInventory: tcard) : boolean;
  procedure playergive (CardFromInventory: tcard);
  procedure playerstoppedtogive;
  procedure givecards;
  function canplayercover: boolean;
  procedure changeofleaderindex;
  function AIcancover : boolean;

private



  procedure changecondition(i : integer);
  function takecondition: integer;


  procedure havetoprocessing (result : boolean);
  procedure AImain;
  procedure sortCardsSuitandNumber(List, List1, List2, List3, superList : TList);
  procedure systemofchoosingcard;
end;



implementation

uses Math;

procedure Shuffle(List : TList); // функция для перемешивания карт
var i, j : integer; obj : pointer;
begin
  for i := List.Count - 1 downto 0 do begin
    j := floor(random() * (i + 1));
      obj := List[j];
      List[j] := List[i];
      List[i] := obj;
    end;
    //Form2.Memo1.Lines.Append(IntToStr(Tcard(List[i]).Number));//это вывод в form2
    //Form2.Memo1.Lines.Append(IntToStr(Tcard(List[i]).suit));//это вывод в form2
end;

constructor Tguy.create (numberplaceforguy : integer);
begin
  cards := TList.Create;
  numberplace:= numberplaceforguy;
  isplaying := true;
  b5 := -1;
  b4 := -1;
  b3 := -1;
  b6 := -1;
  b7 := -1;
  b8 := -1;
end;

constructor Tplaytable.create(players:integer);
var i, j, k : integer;
  g : Tguy;
  cover, switch: boolean;
begin       
  guys := TList.create;
  card6 := TList.Create;
  covercard6 := TList.Create;
  countofplayers := players;
  arrayofallcards := TList.create;
  //countofplayers := 2;
  for i := 0 to countofplayers-1 do begin
    g := Tguy.create(i);
    guys.Add(Pointer(g));
  end;
  for i := 0 to 5 do begin
    covercard6.add(nil);
  end;
  leaderindex := countofplayers-1 ;
 for i := 1 to 13 do begin
    for j := 1 to 4 do begin
      arrayofallcards.Add(Tcard.create(i, j));
    end;
  end;
  Shuffle(arrayofallcards);
  supercard := random(-3)+4 ;

  {tguy(guys[0]).cards.Add(Pointer(tcard.create(1, 2)));
  tguy(guys[0]).cards.Add(Pointer(tcard.create(10, 4)));
  tguy(guys[0]).cards.Add(Pointer(tcard.create(1, 1)));
  tguy(guys[1]).cards.Add(Pointer(tcard.create(12, 2)));
  tguy(guys[0]).cards.Add(Pointer(tcard.create(12, 1)));
  tguy(guys[0]).cards.Add(Pointer(tcard.create(13, 1)));

  tguy(guys[1]).cards.Add(Pointer(tcard.create(1, 2)));
  tguy(guys[1]).cards.Add(Pointer(tcard.create(1, 4)));
  tguy(guys[1]).cards.Add(Pointer(tcard.create(1, 1)));
  tguy(guys[1]).cards.Add(Pointer(tcard.create(1, 2)));
  tguy(guys[1]).cards.Add(Pointer(tcard.create(1, 4)));

  card6.Add(Pointer(tcard.create(1, 4)));
  card6.Add(Pointer(tcard.create(1, 3)));}

  leaderindex := 0;
  //supercard := 1;
  {canplayercover;
  canTransfer(switch);
  if cover and switch then changecondition(5)
  else if cover and (not switch) then changecondition(2)
  else if (not cover) and (not switch) then changecondition(7)
  else if (not cover) and  switch then changecondition(8);}
  if leaderindex = 0 then condition := 0 else condition := 3;
end;

constructor Tcard.create (numberofcard, suitofcard : integer);
begin
  number := numberofcard;
  suit := suitofcard;
  iscardcovered := false;
end;

destructor Tplaytable.destroy;
begin
  guys.Free;
  arrayofallcards.Free;
  card6.Free;
  covercard6.Free;
end;

destructor Tguy.destroy;
begin
  cards.Free;
end;

function Tplaytable.canTransfer(card:Tcard): boolean;//функция для того чтобы понимать может ли игрок перевести
var L, j, i : integer;
begin
  result := false;
  if card <> nil then begin
    L := tcard(card6[0]).number;
    {for i := 0 to tguy(guys[0]).cards.Count-1 do begin
      if L = tcard(tguy(guys[0]).cards[i]).number then result := true;
    end;}
    j := 0;
    while (j <= tguy(guys[leaderindex]).cards.Count-1) and (tcard(tguy(guys[leaderindex]).cards[j]) <> card) do begin
      j := j + 1;
    end;
    if (j <= (tguy(guys[leaderindex]).cards.Count-1))  and (tguy(guys[nextleaderindex]).cards.Count >= card6.Count+1) then begin
      if (card.number = L) then begin
        result := true;
      end
      else result := false;
    end
    else result := false;
  end;
  for i := 0 to covercard6.Count-1 do
    if  covercard6[i] <> nil then result := false;
end;

procedure Tplaytable.switchdefender(card:Tcard);  //чел (живой) переводит карты потому что у него есть чем  // может сделать перевод пдкинув несколько карт
var i, L, j : integer;
  a : array [0..5] of integer;
  f : boolean;
begin
  //Form2.Memo1.Lines.Append('led ' + inttostr(leaderindex));
  if canTransfer(card) then begin
    card6.Add(card);
    tguy(guys[leaderindex]).cards.Remove(card);
    //if leaderindex = 0 then
    changeofleaderindex;
    AImain;
    Form2.Memo1.Lines.Append('проверка switchdefender ' + inttostr(condition));
  end;

  Form2.Memo1.Lines.Append(' ');  //это все тоже вывод
  for i := 0 to Tguy(guys[nextleaderindex]).cards.Count-1 do
    Form2.Memo1.Lines.Append('карта защищающегося после подкида ' +IntToStr(Tcard((Tguy(guys[nextleaderindex])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(guys[nextleaderindex])).cards[i]).suit));
  {Form2.Memo1.Lines.Append(' ');
  for i := 0 to card6.Count-1 do
    Form2.Memo1.Lines.Append('карта на столе после подкида ' +IntToStr((Tcard(card6[i])).number) + ' ' + IntToStr((Tcard(card6[i])).suit) + ' '+ inttostr(supercard));
  Form2.Memo1.Lines.Append(' ');
  Form2.Memo1.Lines.Append(IntToStr(nextleaderindex)); }
  //canTransfer(f);
  //if f then tguy(guys[0]).b4 := 1;
end;

procedure Tplaytable.changecondition(i : integer);
begin
  Tguy(guys[0]).condition := i;
end;

function Tplaytable.takecondition: integer;
begin
  takecondition := Tguy(guys[0]).condition;
end;

procedure Tplaytable.givecards; //добавляет в их списки карты из раздачи если там они есть
var i, n, j : integer;
begin
  for i := 0 to guys.Count-1 do begin
    if (arrayofallcards.Count > 0) and (Tguy(guys[i]).cards.Count < 6) then begin
      for j := Tguy(guys[i]).cards.Count to 5 do begin
        if  arrayofallcards.Count > 0 then Tguy(guys[i]).cards.Add(arrayofallcards[0]);
        arrayofallcards.Delete(0);
      end;
    end
    else if Tguy(guys[i]).cards.Count < 1 then Tguy(guys[i]).isplaying:= false;
  end;
end;

procedure Tplaytable.havetoprocessing(result : boolean);  //проверяет закончена ли игра
var i, n, j : integer;
begin
  result := false;
  if Tguy(guys[0]).isplaying then begin
    for i := 0 to guys.Count-1 do begin
      if (Tguy(guys[i]).isplaying = true) then begin
        n := n + 1;
      end
      else guys.Remove(guys[i]);
    end;
    if n > 1 then result := true;
  end;
end;

function Tplaytable.nextleaderindex : integer;
begin
  result := (leaderindex + 1) mod guys.Count;
end;

procedure Tplaytable.changeofleaderindex;
begin
  leaderindex := nextleaderindex;
end;

procedure Tplaytable.systemofchoosingcard ;      // система выбора карт для начальных кидков, учитывает козырность и номер, может подкинуть несколько карт
var prorities : array [0..51] of integer;
  i, m, countofnewlist : integer;
  g : Tguy;
begin
    g := Tguy(guys[leaderindex]);
    for i := 0 to g.cards.Count-1 do begin
      if tcard(g.cards[i]).suit <> supercard then begin
        prorities[i] := 13 - Tcard(g.cards[i]).number ;
      end
      else prorities[i] := Tcard(g.cards[i]).number - 13;
    end;
    m := 0;
    for i := 0 to g.cards.Count-1 do
      m := max(m, prorities[i]);
    for i := g.cards.Count-1 downto 0 do  begin
      if prorities[i] = m then begin
        card6.Add(g.cards[i]);
        g.cards.remove(g.cards[i]);
      end;
    end;
    changeofleaderindex;
    for i := 0 to Tguy(guys[leaderindex]).cards.Count-1 do
      Form2.Memo1.Lines.Append('карта нападающего ' +IntToStr(Tcard((Tguy(guys[leaderindex])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(guys[leaderindex])).cards[i]).suit));

end;

procedure Tplaytable.sortCardsSuitandNumber(List, List1, List2, List3, superList : TList);  //пока что сортирует тлько по масти потом доделаю
var a, b, c, i : integer;
  //Comparison: TComparison<tcard>;
begin
{  Comparison :=
  function(const Left, Right: tcard): Integer
  begin
    Result := Left.number-Right.number;
  end;
  a := (supercard + 1) mod 4; //первая масть, List1
  b := (supercard + 2) mod 4; //вторая масть, List2
  c := (supercard + 3) mod 4; //третья масть, List3
  for i := 0 to List.count-1 do begin  //сортировка по масти
    if Tcard(List[i]).suit = a then List1.Add(List[i])
    else if Tcard(List[i]).suit = b then List1.Add(List[i])
    else if Tcard(List[i]).suit = c then List1.Add(List[i])
    else if Tcard(List[i]).suit = supercard then List1.Add(List[i]);
  end;
  List1.Sort(TComparer<tcard>.Construct(Comparison));}
end;

function Tplaytable.AIcancover : boolean;
var i, j ,k, s6, n6, count, count1 : integer;
    c : Tcard;
    x : boolean;
begin
  result := false;
  for i := 0 to card6.Count-1 do begin
    if tcard(covercard6[i]) <> nil then continue;
    s6 := tcard(card6[i]).suit;
    n6 := tcard(card6[i]).number;
    c := nil;
    for j := 0 to GetPlayerCardsCount(leaderindex)-1 do begin
      if GetPlayerCard(leaderindex, j).suit = s6 then begin
        if n6<GetPlayerCard(leaderindex, j).number then
          if c = nil then c := GetPlayerCard(leaderindex, j)
          else if c.number > GetPlayerCard(leaderindex, j).number then c := GetPlayerCard(leaderindex, j);
          //covercard6[i]:= GetPlayerCard(leaderindex, j);
      end;
      //covercards(GetPlayerCard(leaderindex, j), tcard(card6[i]));
    end;
    if c <> nil then covercards(c, tcard(card6[i]));
  end;

  for i := 0 to card6.Count-1 do begin
    if tcard(covercard6[i]) <> nil then continue;
    s6 := tcard(card6[i]).suit;
    n6 := tcard(card6[i]).number;
    c := nil;
    for j := 0 to GetPlayerCardsCount(leaderindex)-1 do begin
      if GetPlayerCard(leaderindex, j).suit = supercard then begin
        if (s6 <> supercard) or ((s6 = supercard) and (n6<GetPlayerCard(leaderindex, j).number)) then
          if c = nil then c := GetPlayerCard(leaderindex, j)
          else if (s6 <> supercard) or (c.number > GetPlayerCard(leaderindex, j).number) then c := GetPlayerCard(leaderindex, j);
          //covercard6[i]:= GetPlayerCard(leaderindex, j);
      end;
      //covercards(GetPlayerCard(leaderindex, j), tcard(card6[i]));
    end;
    if c <> nil then covercards(c, tcard(card6[i]));
  end;

  x := true;
  for i := 0 to card6.Count-1 do begin
    if covercard6[i] = nil then x := false;
  end;
  result := x;
  if not x then take;
end;

procedure Tplaytable.AImain;
var i, j : integer;
    b : boolean;
begin
  while leaderindex <> 0 do begin
    if card6.Count = 0 then begin
      systemofchoosingcard;
    end
    else if card6.Count > 0 then begin
      j := 0;
      b := false;
      while j <= GetPlayerCardsCount(leaderindex)-1 do begin
        if cantransfer(GetPlayerCard(leaderindex, j)) then begin
          b := true;
         switchdefender(GetPlayerCard(leaderindex, j));
         j := GetPlayerCardsCount(leaderindex);
        end;
        j := j + 1;
      end;
    if not b then
      AIcancover;
    end;
    givecards;
    for i := 0 to GetPlayerCardsCount(1)-1 do begin
      Form2.Memo1.Lines.Append('карты первго ' + inttostr(GetPlayerCard(1, i).number) + ' ' + inttostr(GetPlayerCard(1, i).suit));
    end;
  end;
  condition := 0;
end;

function Tplaytable.GetPlayerCardsCount(indexofplayer:Integer): Integer;
begin
  result := Tguy(guys[indexofplayer]).cards.Count;
end;

function Tplaytable.GetPlayerCard(indexofplayer, indexofcard:Integer): Tcard;
begin
  result := Tcard(Tguy(guys[indexofplayer]).cards[indexofcard]);
end;

procedure Tplaytable.take;
var i : integer;
begin
  Form2.Memo1.Lines.Append('led - ' + inttostr(leaderindex));
  for i := card6.Count-1 downto 0 do begin
    Tguy(guys[leaderindex]).cards.Add(card6[i]);
  end;
  for i := covercard6.Count-1 downto 0 do begin
    if covercard6[i] <> nil then begin
      tguy(guys[leaderindex]).cards.Add(covercard6[i]);
    end;
  end;
  tableClean;
  for i := 0 to card6.Count-1 do
    Form2.Memo1.Lines.Append('картs нас столе после взятия ' +IntToStr(Tcard(card6[i]).number) + ' ' + IntToStr(Tcard(card6[i]).number));
  givecards;
  changeofleaderindex;
  //changecondition(4);
  //nextleaderindex := (leaderindex + 1) mod guys.Count;
  AImain;
  //Form2.Memo1.Lines.Append('проверка ' + inttostr(condition));
end;


procedure Tplaytable.covercards (CardFromInventory, OnTableCard : Tcard); //процедура для покрытия карт
var i, s : integer;
begin
  //Form2.Memo1.Lines.Append(booltostr(canplayercover) + ' covercards');
  if canplayercover and (((OnTableCard.suit <> supercard) and (CardFromInventory.suit = supercard)) or
                         ((OnTableCard.suit = CardFromInventory.suit) and (OnTableCard.number < CardFromInventory.number))) then begin
    i := 0;
     while (i <= card6.Count-1) and (OnTableCard <> Tcard(card6[i])) do begin //поиск индекса карты на столе
       i := i + 1;
    end;
    tguy(guys[leaderindex]).cards.Remove(CardFromInventory);
    covercard6[i]:= CardFromInventory;

    if i <= card6.Count-1 then covercard6[i] := (CardFromInventory);
    condition := 1;
    Form2.Memo1.Lines.Append('проверка ' + inttostr(condition));
  end;
  s := 0;
  for i := 0 to card6.Count-1 do begin
    if tcard(covercard6[i])<> nil then s := s + 1;
  end;
  if s = card6.Count then begin
    tableClean;
    givecards;
    condition := 2;
    Form2.Memo1.Lines.Append('проверка ' + inttostr(condition));
  end;
end;

function Tplaytable.canplayercover : boolean; // эта процедура проверяет может ли чел покрыть вообще
var i, j, a, a1, b1, b, s : integer;
begin
  result := false;
  for i := 0 to card6.Count-1 do begin
    a1 := tcard(card6[i]).number;
    b1 := tcard(card6[i]).suit;
    for j := 0 to GetPlayerCardsCount (leaderindex)-1 do begin
       a := GetPlayerCard(leaderindex, j).number;
       b := GetPlayerCard(leaderindex, j).suit;
       if (b1 <> supercard) and (b = supercard) and (covercard6[i] = nil) then begin
        result := true;
       end
       else begin
        if (b1 = b) and (a>a1)  and (covercard6[i] = nil) then  begin
         if a > a1 then  begin  result := true;  end;
        end;
       end;
    end;
  end;
  s := 0;
  for i := 0 to card6.Count-1 do begin
    if tcard(covercard6[i])<> nil then s := s + 1;
  end;
  //Form2.Memo1.Lines.Append('s = ' + inttostr(s));
  //Form2.Memo1.Lines.Append('u = ' + booltostr(u));
  //Form2.Memo1.Lines.Append('card6.Count = ' + inttostr(card6.Count));
  {if s = card6.Count then begin
   tguy(guys[0]).b3 := 0;
   tguy(guys[0]).b6 := 1;
   //changeofleaderindex;}
   Form2.Memo1.Lines.Append('lead ' + inttostr(leaderindex));

end;
  //Form2.Memo1.Lines.Append(booltostr(u));


function Tplaytable.canplayergive (CardFromInventory: tcard) : boolean;
var i, L : integer;
begin
  result := false;
  {if (tguy(guys[playerindex]).cards.Count <= 0) then begin
    ///закрытие
  end
  else}
  if (card6.count <= 0) and (tguy(guys[leaderindex]).cards.Count > 0) then begin
    result := true;
  end
  else  begin
    L :=tcard(card6[0]).number ;
    //Form2.Memo1.Lines.Append(inttostr(L) + '  kl;k  ' + inttostr(card6.Count));
    //for i := 0 to (tguy(guys[leaerindex]).cards).Count-1 do begin
    if CardFromInventory.number = L then result := true;
    //end;
      //Form2.Memo1.Lines.Append(booltostr(u) + '  kl;k  ');
  end;
end;

procedure Tplaytable.playergive (CardFromInventory: tcard);
var i : integer;
begin
  if canplayergive(CardFromInventory) and (GetPlayerCardsCount(nextleaderindex) > card6.Count) then begin
    tguy(guys[leaderindex]).cards.Remove(CardFromInventory);
    card6.add(CardFromInventory);
    condition := 2;
  end
  else AImain;
  Form2.Memo1.Lines.Append('проверка ' + inttostr(condition));
end;

procedure Tplaytable.playerstoppedtogive;
begin
  if card6.Count <> 0 then begin
    changeofleaderindex;
    AImain;
    Form2.Memo1.Lines.Append('проверка ' + inttostr(condition));
  end;
end;

procedure Tplaytable.tableClean;
var i : integer;
begin
  card6.Clear;
  for i := 0 to covercard6.Count - 1  do begin
      covercard6[i] := nil;
  end;
end;

end.
