unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unit3 ;

type
Tcard = class//1 - красные сердечки, 2 - черные сердечки, 3 - красная оставшаяся фигура, 4 - черная оставшаяся фигура
private
public
  number : integer; //чем больше тем круче 13 - туз
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
  leaderindex : integer;// чел который ходит ((1..7) mod 8)
  supercard : integer;
  countofplayers : integer;
  guys : array [1..7] of Tguy;
  card6 : array [1..6] of Tcard;
  arrayofallcards : TList;//колода карт
  constructor create(players:integer);
  destructor destroy;
  procedure main;
  function havetoprocessing : boolean;
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
   for i := 0 to List.Count-1 do
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
  leaderindex := 1 + random (6); // пока что рандомно а не по меньшей козырной ((((((
  countofplayers := players;
  arrayofallcards := TList.create;
  for i := 1 to countofplayers do begin //создание игроков перенесено в конструктор стола
    guys[i] := Tguy.create(i);
    //if guys[i].isplaying = true then  Form2.Memo1.Lines.Append('true');
  end;
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
  for i := 1 to countofplayers do begin
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


procedure Tplaytable.main;
var i, j : integer;
begin
  while (havetoprocessing = true) do begin
    //    А ТУТ ДОЛЖНО НАЧАТЬСЯ ИИ Σ(°△°|||)︴
  end;
end;
end.

