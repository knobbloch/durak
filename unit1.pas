unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls
  , Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    ComboBox1: TComboBox;
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image2: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image29: TImage;
    Image3: TImage;
    Image30: TImage;
    Image31: TImage;
    Image32: TImage;
    Image33: TImage;
    Image34: TImage;
    Image35: TImage;
    Image36: TImage;
    Image37: TImage;
    Image38: TImage;
    Image39: TImage;
    Image4: TImage;
    Image40: TImage;
    Image41: TImage;
    Image42: TImage;
    Image43: TImage;
    Image44: TImage;
    Image45: TImage;
    Image46: TImage;
    Image47: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
    procedure CoverImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
    procedure MastoEndmas;
  private     //ой упс ахах это же поля формы
    flag : boolean;
    images : array [1..6] of Timage;
    guys : array [1..7] of Tguy;
    supercard : integer;
    playtablegame : Tplaytable;
    bito : boolean;//рисовать текстуру сыгранных карт или нет
  public
  end;

var
  Form1: TForm1;
  mas : array[15..40] of TImage;
  end_mas : array[1..6] of TImage;
  cover_mas : array[1..6] of TImage;
  move: boolean;
  cover_img, last_img: integer;

implementation
{$R *.lfm}

uses
  Unit3;

procedure TForm1.Button1Click(Sender: TObject);
var i, j : integer; card : Tcard; obj : pointer;
begin
  button4.Show;
  flag := true;
  randomize;
  playtablegame := Tplaytable.create(StrtoInt(ComboBox1.Items[ComboBox1.ItemIndex]));
  ComboBox1.Hide;
  Button1.Hide;
  Image1.tag := 0; Image2.tag := 0; Image3.tag := 0; Image4.tag := 0; Image5.tag := 0; Image6.tag := 0;
  playtablegame.givecards;
  Button3.Visible := True;
  last_img := 0;
  mas[15] := Image15; mas[16] := Image16; mas[17] := Image17; mas[18] := Image18;
  mas[19] := Image19; mas[20] := Image20; mas[21] := Image21; mas[22] := Image22;
  mas[23] := Image23; mas[24] := Image24; mas[25] := Image25; mas[26] := Image26;
  mas[27] := Image27; mas[28] := Image28; mas[29] := Image29; mas[30] := Image30;
  mas[31] := Image31; mas[32] := Image32; mas[33] := Image33; mas[34] := Image34;
  mas[35] := Image35; mas[36] := Image36; mas[37] := Image37; mas[38] := Image38;
  mas[39] := Image39; mas[40] := Image40;
  end_mas[1] := Image1; end_mas[2] := Image2; end_mas[3] := Image3;
  end_mas[4] := Image4; end_mas[5] := Image5; end_mas[6] := Image6;
  cover_mas[1] := Image42; cover_mas[2] := Image43; cover_mas[3] := Image44;
  cover_mas[4] := Image45; cover_mas[5] := Image46; cover_mas[6] := Image47;
  for i := 1 to Length(end_mas) do
      end_mas[i].tag := 0;
  for i := 1 to Length(cover_mas) do
      cover_mas[i].tag := 0;
  for i := Low(mas) to High(mas) do
      mas[i].tag := 0;
  j := 0;
  for j := 0 to playtablegame.playerCardsCount - 1 do begin
      i := 15 + j * 2;
      mas[i].Picture.LoadFromFile('img\' + inttostr(playtablegame.playerCards[j].suit) +
                       '_' + inttostr(playtablegame.playerCards[j].number) + '.png');
      mas[i].tag := playtablegame.playerCards[j].suit * 100 +
                       playtablegame.playerCards[j].number;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button3Click(Sender: TObject);//это кнопка забрать карты
var i, j, k : integer;
    add_card : array[1..12] of integer;
begin
  // и тут тоже проверка мой ли ход
  last_img := 0;
  cover_img := 0;
  playtablegame.take;
  k := 0;
  for i := 1 to Length(end_mas) do
      if end_mas[i].tag <> 0 then begin
        k := k + 1;
        add_card[k] := end_mas[i].tag;
        end_mas[i].tag := 0;
        end_mas[i].Picture := nil;
      end;
  for i := 1 to Length(cover_mas) do
      if cover_mas[i].tag <> 0 then begin
        k := k + 1;
        add_card[k] := cover_mas[i].tag;
        cover_mas[i].tag := 0;
        cover_mas[i].Picture := nil;
      end;
  for j := 1 to k do begin
      if mas[j + 14].tag = 0 then begin
         mas[j + 14].Picture.LoadFromFile('img\' + inttostr(add_card[j] div 100) +
                         '_' + inttostr(add_card[j] mod 100) + '.png');
         mas[j + 14].tag := add_card[j];
      end;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);   //проверка перевода
var card, cc : Tcard;
    g : Tguy;
    nums : array[1..12] of integer;
    k, i : integer;
    stop : boolean;
begin
  g := Tguy(playtablegame.guys[0]);
  playtablegame.systemofchoosingcard;
  card := Tcard(g.cards[0]);//вместо card подставить карту которая новая добавляестя в card6
  playtablegame.switchdefender(card);

  k := 0;
  for i := 1 to Length(end_mas) do begin
      if end_mas[i].tag mod 100 <> 0 then begin
         k := k + 1;
         nums[k] := end_mas[i].tag mod 100
      end;
      if cover_mas[i].tag mod 100 <> 0 then begin
         k := k + 1;
         nums[k] := cover_mas[i].tag mod 100
      end;
  end;
  stop := False;
  for i := 1 to k do
     if (mas[last_img].tag mod 100 = nums[i]) and (not stop) then begin
       MasToEndmas;
       stop := True;
     end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var card : Tcard;//в эту карту нужно добавить карту, которая выбирается игроком
begin
  //playtablegame.covercards; //если карты неподходящие то кнопка просто не сработает
  //ну и тут тоже должна быть проверка мой ли это ход
  if (cover_img <> 0) and (last_img <> 0) and
      (((mas[last_img].tag div 100 = end_mas[cover_img].tag div 100) and
      (mas[last_img].tag mod 100 > end_mas[cover_img].tag mod 100)) or
      ((mas[last_img].tag div 100 = playtablegame.supercard) and
      (end_mas[cover_img].tag div 100 <> supercard))) then begin
        cover_mas[cover_img].Picture.LoadFromFile('img\' + inttostr(mas[last_img].tag div 100) + '_' + inttostr(mas[last_img].tag mod 100) + '.png');
        cover_mas[cover_img].tag := mas[last_img].tag;
        mas[last_img].Picture := nil;
        mas[last_img].tag := 0;
        last_img := 0;
        cover_img := 0;
        Shape1.Visible := False;
        Shape2.Visible := False;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  playtablegame.changeofleaderindex;
end;

procedure TForm1.Button7Click(Sender: TObject);
var i : integer;
    stop : boolean;
begin
  //if playtablegame.leaderindex = 1 then begin
     MasToEndmas;
  //end;
end;

procedure TForm1.Button4Click(Sender: TObject);   //проверка перевода
var card, cc : Tcard;
  g : Tguy;
begin
  g := Tguy(playtablegame.guys[0]);
  playtablegame.systemofchoosingcard;
  card := Tcard(g.cards[0]);//вместо card подставить карту которая новая добавляестя в card6
  playtablegame.switchdefender(card);
end;

procedure TForm1.Button5Click(Sender: TObject);
var card : Tcard;//в эту карту нужно добавить карту, которая выбирается игроком

begin
  //playtablegame.covercards; //если карты неподходящие то кнопка просто не сработает
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  playtablegame.changeofleaderindex;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  ComboBox1.Items.Add('2');
  ComboBox1.Items.Add('3');
  ComboBox1.Items.Add('4');
  ComboBox1.Items.Add('5');
  ComboBox1.Items.Add('6');
  ComboBox1.Items.Add('7');
  ComboBox1.ItemIndex:= 5;
  Constraints.MinHeight := 782;     // 525 840
  Constraints.MinWidth := 1680;
  Constraints.MaxHeight := 782;
  Constraints.MaxWidth := 1680;

  Form2 := TForm2.Create(Self);
  Form2.show;
  button4.Hide;
end;

procedure TForm1.MasToEndmas;
var stop : boolean;
    i : integer;
begin
    stop := False;
    if (last_img <> 0) then
      for i := 1 to Length(end_mas) do
          if (end_mas[i].tag = 0) and (not stop) then begin
                end_mas[i].tag := mas[last_img].tag;
                end_mas[i].Picture.LoadFromFile('img\' + inttostr(mas[last_img].tag div 100) + '_' + inttostr(mas[last_img].tag mod 100) + '.png');
                mas[last_img].Picture := nil;
                mas[last_img].tag := 0;
                last_img := 0;
                Shape1.Visible := False;
                stop := True;
          end;
end;

procedure TForm1.CoverImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i : integer;
begin
  // на меня ходят?
   if flag = true then begin
     cover_img := 0;
     for i := Low(end_mas) to High(end_mas) do begin
        if  (Mouse.CursorPos.x - Form1.Left >= end_mas[i].Left) and (end_mas[i].tag <> 0) and
            (Mouse.CursorPos.x - Form1.Left <= end_mas[i].Width + end_mas[i].Left) and
            (Mouse.CursorPos.y - Form1.Top >= end_mas[i].Top) and
            (Mouse.CursorPos.y - Form1.Top <= end_mas[i].Top + end_mas[i].Height) and
            (cover_mas[i].tag = 0) then begin
              cover_img := i;
              Shape2.Left := end_mas[cover_img].Left - 5;
              Shape2.Top := end_mas[cover_img].Top - 3;
              Shape2.Visible := True;
        end;
     end;
   end;
end;

procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i : integer;
begin
   if flag = true then begin
     last_img := 0;
     for i := Low(mas) to High(mas) do
        if  (Mouse.CursorPos.x - Form1.Left >= mas[i].Left) and (mas[i].tag <> 0) and
            (Mouse.CursorPos.x - Form1.Left <= mas[i].Width + mas[i].Left) and
            (Mouse.CursorPos.y - Form1.Top >= mas[i].Top) and
            (Mouse.CursorPos.y - Form1.Top <= mas[i].Top + mas[i].Height) then begin
            last_img := i;
            Shape1.Left := mas[last_img].Left - 5;
            Shape1.Top := mas[last_img].Top - 3;
            Shape1.Visible := True;
        end;
   end;
end;

end.
