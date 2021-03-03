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
public
  leaderindex : integer;// чел который подкидывает ((1..7) mod 8)
  supercard : integer;
  countofplayers : integer;
  guys : array [1..7] of Tguy; // игрок всегда перый гай!!
  card6 : TList;//вот они те самые 6 карт из за которых замес
  arrayofallcards : TList;//колода карт
  constructor create(players:integer);
  destructor destroy;
  procedure firstpodkid;
  function havetoprocessing : boolean;
  procedure systemofchoosingcard (Listofplayer, returnList : TList);
  procedure changeofcourse;
  procedure take;
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
   //for i := 0 to List.Count-1 do
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
begin
  card6 := TList.Create;
  countofplayers := players;
  arrayofallcards := TList.create;
  for i := 1 to countofplayers do begin //создание игроков перенесено в конструктор стола
    guys[i] := Tguy.create(i);
    //if guys[i].isplaying = true then  Form2.Memo1.Lines.Append('true');
  end;
  leaderindex := countofplayers ; // пока что игрок ходит первым
  for i := 1 to 52 do begin   // заполнение колоды
    for j := 1 to 4 do begin
        arrayofallcards.Add(Tcard.create(i, j));
    end;
  end;
  Shuffle(arrayofallcards);
  supercard := random(-3)+4;
end;

destructor Tplaytable.destroy;
begin
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



function Tplaytable.havetoprocessing: boolean;  //проверяет закончера ли игра, добавляет в их списки карты
var i, n, j : integer;
  begin
  for i := 2 to countofplayers do begin
    if (guys[i].isplaying = true) then begin
        n := n + 1;
        if (arrayofallcards.Count > 0) and (guys[i].cards.Count < 6) then begin
          for j := guys[i].cards.Count to 6 do begin
            if  arrayofallcards.Count > 0 then guys[i].cards.Add(arrayofallcards[0]);
            arrayofallcards.Delete(0);
          end;
        end;
    end;
  end;
  if n <= 1 then havetoprocessing := false else havetoprocessing := true;
end;

procedure Tplaytable.systemofchoosingcard (Listofplayer, returnList : TList) ;// система выбора карт для начальных кидков, учитывает козырность и номер
var prorities : array [0..51] of integer;                               //ннужно чтобы еще была система ддля подкидов уже во время хода когда не пас
  i, m, o, countofnewlist : integer;
begin
  for i := 0 to Listofplayer.Count - 1 do begin
    if Tcard(Listofplayer[i]).suit <> supercard then begin
      prorities[i] := 13 + Tcard(Listofplayer[i]).number;
    end
    else prorities[i] := Tcard(Listofplayer[i]).number;
    end;
  for i := 0 to 51 do
    m := max(m, prorities[i]);
  o := 0;
  for i := 0 to 51 do  begin
    if prorities[i] = m then begin
      returnList.Add(Listofplayer[o]);
      o := o+1;
    end;
  end;
end;

procedure Tplaytable.firstpodkid; // подкиды начальные  //  я хз почему все это делается через 3 функции а не через 1
var List : TList;
begin
  if (havetoprocessing = true) then begin
    List := TList.Create;
    systemofchoosingcard(guys[leaderindex].cards, List);
    List.Free;
  end;
end;

procedure Tplaytable.changeofcourse;
begin
  leaderindex := ((leaderindex + 1) mod countofplayers)+1;
end;

procedure Tplaytable.take; //Эта функция мной не проверена по причине дз по математике!
var i : integer;
begin
  changeofcourse;
  for i := 0 to card6.Count-1 do begin
    guys[leaderindex].cards.Add(card6[i]);
  end;
end;

end.

