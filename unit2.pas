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
  constructor create (numberofcard, suitofcard : integer);
end;

Tguy = class
private
public
  isplaying : boolean; //закончил ли игрок играть
  numberplace : integer;
  //cards: array[1..6] of Tcard;
  cards : TList;
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
  procedure switchdefender(card:Tcard);
  procedure covercards (card : Tcard);
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
end;

constructor Tplaytable.create(players:integer);
var i, j : integer;
  g : Tguy;
begin
  guys := TList.create;
  card6 := TList.Create;
  countofplayers := players;
  arrayofallcards := TList.create;
  for i := 0 to countofplayers-1 do begin
    g := Tguy.create(i);
    guys.Add(Pointer(g));
  end;
  leaderindex := countofplayers-1 ;
  for i := 1 to 13 do begin
    for j := 1 to 4 do begin
      arrayofallcards.Add(Tcard.create(i, j));
    end;
  end;
  Shuffle(arrayofallcards);
  supercard := random(-3)+4;
end;

destructor Tplaytable.destroy;
begin
  guys.Free;
  arrayofallcards.Free;
  card6.Free;
end;




destructor Tguy.destroy;
begin
  cards.Free;
end;

constructor Tcard.create (numberofcard, suitofcard : integer);
begin
  number := numberofcard;
  suit := suitofcard;
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
end;

procedure Tplaytable.sortCardsSuitandNumber(List, List1, List2, List3, superList : TList);  //пока что сортирует тлько по масти потом доделаю
var a, b, c, i : integer;
begin
  a := (supercard + 1) mod 4; //первая масть, List1
  b := (supercard + 2) mod 4; //вторая масть, List2
  c := (supercard + 3) mod 4; //третья масть, List3
  for i := 0 to List.count-1 do begin  //сортировка по масти
    if Tcard(List[i]).suit = a then List1.Add(List[i])
    else if Tcard(List[i]).suit = b then List1.Add(List[i])
    else if Tcard(List[i]).suit = c then List1.Add(List[i])
    else if Tcard(List[i]).suit = supercard then List1.Add(List[i]);
  end;
  //for i
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
  for i := 0 to card6.Count-1 do begin
    Tguy(guys[leaderindex]).cards.Add(card6[i]); // add подкинутые
  end;
  changeofleaderindex;
  givecards;
end;

procedure Tplaytable.switchdefender(card:Tcard);  //чел (живой) переводит карты потому что у него есть чем  // может сделать перевод пдкинув несколько карт
var i, L, j, nextleaderindex, nextnextleaderindex: integer;
  a : array [0..5] of integer;
begin
  for i := 0 to card6.Count-1 do   //вывод
    Form2.Memo1.Lines.Append(IntToStr((Tcard(card6[i])).number) + ' ' + IntToStr((Tcard(card6[i])).suit) + ' '+ inttostr(supercard));
  Form2.Memo1.Lines.Append(' ');
  for i := 0 to Tguy(guys[leaderindex]).cards.Count-1 do
    Form2.Memo1.Lines.Append(IntToStr(Tcard((Tguy(guys[leaderindex])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(guys[leaderindex])).cards[i]).suit));

  nextleaderindex := (leaderindex + 1) mod guys.Count;
  nextnextleaderindex := (nextleaderindex + 1) mod guys.Count;

  Form2.Memo1.Lines.Append(' '); //вывод
  for i := 0 to Tguy(guys[nextleaderindex]).cards.Count-1 do
    Form2.Memo1.Lines.Append(IntToStr(Tcard((Tguy(guys[nextleaderindex])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(guys[nextleaderindex])).cards[i]).suit));
   Form2.Memo1.Lines.Append(' ');

  L := Tcard(card6[0]).number;
  j := 0;
  while (j <= tguy(guys[nextleaderindex]).cards.Count-1) and (tcard(tguy(guys[nextleaderindex]).cards[j]) <> card) and (tguy(guys[nextnextleaderindex]).cards.Count >= card6.Count+1) do
    j := j + 1;
  if (tguy(guys[nextleaderindex]).cards.Count >  j) and (card.number = L) then begin
    card6.Add(pointer(card));
    tguy(guys[nextleaderindex]).cards.Remove(tguy(guys[nextleaderindex]).cards[j]);
  end;

  Form2.Memo1.Lines.Append(' ');  //это все тоже вывод
  for i := 0 to Tguy(guys[nextleaderindex]).cards.Count-1 do
    Form2.Memo1.Lines.Append(IntToStr(Tcard((Tguy(guys[nextleaderindex])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(guys[nextleaderindex])).cards[i]).suit));
  Form2.Memo1.Lines.Append(' ');
  for i := 0 to card6.Count-1 do
    Form2.Memo1.Lines.Append(IntToStr((Tcard(card6[i])).number) + ' ' + IntToStr((Tcard(card6[i])).suit) + ' '+ inttostr(supercard));
end;
//вывод: первым выводятся номер и масть карт на столе подкинутые ии и козырная масть, потом карты подкидывающего (без подкинутых карт), потом карты того, кто защищается потом снова кто защищается но уже после возможного перевода, потом снова на столе

procedure Tplaytable.covercards (card : Tcard);
var nextleaderindex : integer;
begin
  nextleaderindex := (leaderindex + 1) mod guys.Count;
end;

end.
