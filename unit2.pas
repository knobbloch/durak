unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unit3 ;

type
Tcard = class//1 - красные сердечки, 2 - черные сердечки, 3 - красная оставшаяся фигура, 4 - черная оставшаяся фигура
private
public
  number : integer;
  suit : integer;
  constructor create (numberofcard, suitofcard : integer);
end;

Tguy = class
private
public
  numberplace : integer;
  //cards: array[1..6] of Tcard;
  cards : TList; //этот класс в теории можно перемешать рандомно (sort)
  constructor create(numberplaceforguy : integer);
  destructor Destroy;
end;

Tplaytable = class
private
public
  supercard : integer;
  countofplayers : integer;
  guys : array [1..7] of Tguy;
  card6 : array [1..6] of Tcard;
  arrayofallcards : TList;//колода карт
  constructor create(players:integer);
  destructor destroy;
end;



implementation

uses Math;

procedure Shuffle(List : TList); // функция для перемешивания карт
var i, j : integer; obj : pointer;
begin
  for i := 0 to List.Count - 1 do begin
    randomize;
    j := floor(random() * (i + 1));
      obj := List[j];
      List[j] := List[i];
      List[i] := obj;
    end;
end;

constructor Tplaytable.create(players:integer);
var i, j : integer;
begin
  countofplayers := players;
  arrayofallcards := TList.create;
  for i := 1 to countofplayers do begin //создание игроков перенесено в конструктор стола
    guys[i] := Tguy.create(i);
  end;
  for i := 1 to 13 do begin   // заполнение колоды
    for j := 1 to 4 do begin
        arrayofallcards.Add(Tcard.create(i, j));
    end;
  end;
  Shuffle(arrayofallcards);
  supercard := random(-3)+4;
  Form2.Memo1.Lines.Append('hello');
end;

destructor Tplaytable.destroy;
begin
   arrayofallcards.Free;
end;


constructor Tguy.create (numberplaceforguy : integer);
begin
  cards := TList.Create;
  numberplace:= numberplaceforguy;
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

end.

