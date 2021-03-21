unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unit3 ;

type
Tcard = class//1 - красные сердечки, 2 - черные сердечки, 3 - красная оставшаяся фигура, 4 - черная оставшаяся фигура
private
public
  number : integer; //чем больше тем круче 13 - туз, 12 - король, 11- дама, 10 - валет,  9 - 10 , 8 - 9, 7 - 8, 6 - 7, 5 - 6, 4 - 5, 3 - 4, 2 - 3, 1 - 2 ой упс как то криво ахах
  suit : integer;
  iscardcovered : boolean; //это для проверки занята ли карта на столе
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
  constructor create(numberplaceforguy : integer);
  destructor Destroy;
end;

Tplaytable = class
private
  function GetPlayerCardsCount: Integer;
  function GetPlayerCard(index:Integer): Tcard;
public
  leaderindex : integer;// чел который подкидывает ((1..7) mod 8)
  supercard : integer;
  countofplayers : integer;
  guys : TList; // игрок всегда нулевой гай!!
  card6 : TList;//вот они те самые 6 карт из за которых замес
  arrayofallcards : TList;//колода карт
  covercard6 : TList;
  constructor create(players:integer);
  destructor destroy;
  procedure havetoprocessing (result : boolean);
  procedure systemofchoosingcard;
  procedure changeofleaderindex;
  procedure take;
  procedure AImain;
  procedure sortCardsSuitandNumber(List, List1, List2, List3, superList : TList);
  property playerCardsCount: Integer read GetPlayerCardsCount;
  property playerCards[index:Integer]: Tcard read GetPlayerCard;
  procedure givecards;
  procedure switchdefender (card:Tcard; var x : boolean);
  procedure covercards (CardFromInventory, OnTableCard : Tcard; var b : boolean);
  procedure canTransfer(var b : boolean);
  procedure canplayercover(var u : boolean);
  procedure changecondition(i : integer);
  function takecondition: integer;
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
  for i := 0 to countofplayers-1 do begin
    g := Tguy.create(i);
    guys.Add(Pointer(g));
  end;
  for i := 0 to 5 do begin
    covercard6.add(nil);
  end;
  leaderindex := countofplayers-1 ;
 {for i := 1 to 13 do begin
    for j := 1 to 4 do begin
      arrayofallcards.Add(Tcard.create(i, j));
    end;
  end;
  Shuffle(arrayofallcards);}
  tguy(guys[0]).cards.Add(Pointer(tcard.create(1, 2)));
  tguy(guys[0]).cards.Add(Pointer(tcard.create(10, 4)));
  tguy(guys[0]).cards.Add(Pointer(tcard.create(1, 1)));
  tguy(guys[1]).cards.Add(Pointer(tcard.create(12, 2)));
  tguy(guys[0]).cards.Add(Pointer(tcard.create(12, 1)));
  tguy(guys[0]).cards.Add(Pointer(tcard.create(13, 1)));
  card6.Add(Pointer(tcard.create(1, 4)));
  card6.Add(Pointer(tcard.create(1, 3)));
  supercard := random(-3)+4 ;

  supercard := 1;
  canplayercover(cover);
  canTransfer(switch);
  if cover and switch then changecondition(5)
  else if cover and (not switch) then changecondition(2)
  else if (not cover) and (not switch) then changecondition(7)
  else if (not cover) and  switch then changecondition(8);
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

constructor Tcard.create (numberofcard, suitofcard : integer);
begin
  number := numberofcard;
  suit := suitofcard;
  iscardcovered := false;
end;

procedure Tplaytable.canTransfer(var b : boolean);//функция для того чтобы понимать может ли игрок перевести
var i, L : integer;
begin
  b := false;
  L := tcard(card6[0]).number;
  for i := 0 to tguy(guys[0]).cards.Count-1 do begin
    if L = tcard(tguy(guys[0]).cards[i]).number then b := true;
  end;
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

procedure Tplaytable.changeofleaderindex;
begin
  leaderindex := (leaderindex + 1) mod guys.Count;
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
  for i := 0 to Tguy(guys[leaderindex]).cards.Count-1 do
    Form2.Memo1.Lines.Append('карта нападающего ' +IntToStr(Tcard((Tguy(guys[leaderindex])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(guys[leaderindex])).cards[i]).suit));
end;

procedure Tplaytable.sortCardsSuitandNumber(List, List1, List2, List3, superList : TList);  //пока что сортирует тлько по масти потом доделаю
var a, b, c, i : integer;
begin
  {a := (supercard + 1) mod 4; //первая масть, List1
  b := (supercard + 2) mod 4; //вторая масть, List2
  c := (supercard + 3) mod 4; //третья масть, List3
  for i := 0 to List.count-1 do begin  //сортировка по масти
    if Tcard(List[i]).suit = a then List1.Add(List[i])
    else if Tcard(List[i]).suit = b then List1.Add(List[i])
    else if Tcard(List[i]).suit = c then List1.Add(List[i])
    else if Tcard(List[i]).suit = supercard then List1.Add(List[i]);
  end;
  //for i}
end;

procedure Tplaytable.AImain;//не дописана
var result : boolean;
begin
  //while havetoprocessing(result : boolean) do begin

    givecards;
  //end;
end;

function Tplaytable.GetPlayerCardsCount: Integer;
begin
  result := Tguy(guys[0]).cards.Count;
end;

function Tplaytable.GetPlayerCard(index:Integer): Tcard;
begin
  result := Tcard(Tguy(guys[0]).cards[index]);
end;

procedure Tplaytable.take;
var i : integer;
begin
  changeofleaderindex;
  Form2.Memo1.Lines.Append('led - ' + inttostr(leaderindex));
  for i := card6.Count-1 downto 0 do begin
    Tguy(guys[leaderindex]).cards.Add(card6[i]); // add подкинутые
    card6.Remove(card6[i]);
  end;
  for i := covercard6.Count-1 downto 0 do begin
    if covercard6[i] <> nil then begin
      tguy(guys[leaderindex]).cards.Add(covercard6[i]);
      covercard6.Remove(covercard6[i]);
    end;
  end;
  givecards;
  changecondition(4);
end;


procedure Tplaytable.switchdefender(card:Tcard; var x : boolean);  //чел (живой) переводит карты потому что у него есть чем  // может сделать перевод пдкинув несколько карт
var i, L, j, nextleaderindex, nextnextleaderindex: integer;
  a : array [0..5] of integer;
  f : boolean;
begin
  x := false;
  tguy(guys[0]).condition := 1;
  nextleaderindex := (leaderindex + 1) mod guys.Count;
  nextnextleaderindex := (nextleaderindex + 1) mod guys.Count;
  L := Tcard(card6[0]).number;
  j := 0;
  while (j <= tguy(guys[nextleaderindex]).cards.Count-1) and (tcard(tguy(guys[nextleaderindex]).cards[j]) <> card) and (tguy(guys[nextnextleaderindex]).cards.Count >= card6.Count+1) do begin
    j := j + 1;
  end;
  if j <= (tguy(guys[nextleaderindex]).cards.Count-1) then begin
    if (tguy(guys[nextleaderindex]).cards.Count >  j) and (card.number = L) then begin
      tguy(guys[0]).condition := 3;
      x := true;
      card6.Add(pointer(card));
      tguy(guys[nextleaderindex]).cards.Remove(card);
    end;
  end;
  tguy(guys[0]).b6 := 1;
  Form2.Memo1.Lines.Append(' ');  //это все тоже вывод
  for i := 0 to Tguy(guys[nextleaderindex]).cards.Count-1 do
    Form2.Memo1.Lines.Append('карта защищающегося после подкида ' +IntToStr(Tcard((Tguy(guys[nextleaderindex])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(guys[nextleaderindex])).cards[i]).suit));
  {Form2.Memo1.Lines.Append(' ');
  for i := 0 to card6.Count-1 do
    Form2.Memo1.Lines.Append('карта на столе после подкида ' +IntToStr((Tcard(card6[i])).number) + ' ' + IntToStr((Tcard(card6[i])).suit) + ' '+ inttostr(supercard));
  Form2.Memo1.Lines.Append(' ');
  Form2.Memo1.Lines.Append(IntToStr(nextleaderindex)); }
  changeofleaderindex;
  canTransfer(f);
  if not f then tguy(guys[0]).b4 := 0;
end;
//вывод: первым выводятся номер и масть карт на столе подкинутые ии и козырная масть, потом карты подкидывающего (без подкинутых карт), потом карты того, кто защищается потом снова кто защищается но уже после возможного перевода, потом снова на столе

procedure Tplaytable.covercards (CardFromInventory, OnTableCard : Tcard; var b : boolean); //процедура для покрытия карт
var nextleaderindex, i : integer;
begin
  nextleaderindex := (leaderindex + 1) mod guys.Count;
  i := 0;
   while (i <= card6.Count-1) and (OnTableCard <> Tcard(card6[i])) do begin //поиск индекса карты на столе
     i := i + 1;
  end;
  if (OnTableCard.suit <> supercard) and (CardFromInventory.suit = supercard) then begin
   b := true;
   tguy(guys[nextleaderindex]).cards.Remove(CardFromInventory);
   OnTableCard.iscardcovered:= true;
   if i <= card6.Count-1 then covercard6[i] := (CardFromInventory);
  end
  else if ((OnTableCard.suit = CardFromInventory.suit) and (OnTableCard.number < CardFromInventory.number)) then begin
   b := true;
   tguy(guys[nextleaderindex]).cards.Remove(CardFromInventory);
   OnTableCard.iscardcovered:= true;
   if i <= card6.Count-1 then covercard6[i] := (CardFromInventory);
  end
  else b := false;
end;

procedure Tplaytable.canplayercover (var u : boolean); // эта процедура проверяет может ли чел покрыть вообще
var i, j, a, a1, b1, b, s : integer;
begin
  u := false;
  for i := 0 to card6.Count-1 do begin
    a1 := tcard(card6[i]).number;
    b1 := tcard(card6[i]).suit;
    for j := 0 to GetPlayerCardsCount-1 do begin
       a := GetPlayerCard(j).number;
       b := GetPlayerCard(j).suit;
       if (b1 <> supercard) and (b = supercard) and (not Tcard(card6[i]).iscardcovered) then begin
        u := true;
       end
       else begin
        if (b1 = b) and (a>a1)  and (not Tcard(card6[i]).iscardcovered) then  begin
         if a > a1 then  begin  u := true;  end;
        end;
       end;
    end;
  end;
  s := 0;
  for i := 0 to card6.Count-1 do begin
    if tcard(card6[i]).iscardcovered then s := s + 1;
  end;
  //Form2.Memo1.Lines.Append('s = ' + inttostr(s));
  Form2.Memo1.Lines.Append('u = ' + booltostr(u));
  //Form2.Memo1.Lines.Append('card6.Count = ' + inttostr(card6.Count));
  if s = card6.Count then begin
   changeofleaderindex;
  end;
  {else if not u then begin
   changeofleaderindex;
   changeofleaderindex;
  end;}
  Form2.Memo1.Lines.Append(booltostr(u));
  ///hdh
end;


end.
