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
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ImageDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ImageEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseEnter(Sender: TObject);
    procedure ImageMouseLeave(Sender: TObject);
  private
    images : array [1..6] of Timage;//чтобы было красиво в теории нужно убрать эти глоб переменные но я щас не буду это делать
    guys : array [1..7] of Tguy;
    remainingcard: integer;
    supercard : integer;
    playtablegame : Tplaytable;
    bito : boolean;//рисовать текстуру сыгранных карт или нет
  public
  end;

var
  Form1: TForm1;
  mas : array[15..40] of TImage;
  end_mas : array[1..6] of TImage;
  move: boolean;
  x, y, x0, y0, start_x, start_y, last_img: integer;
  rec : TRect;
  draggg : boolean;
  MyMouse: TMouse;

implementation
{$R *.lfm}

uses
  Unit3;

procedure TForm1.Button1Click(Sender: TObject);
var i, j : integer; card : Tcard; obj : pointer;
begin
  randomize;
  playtablegame := Tplaytable.create(StrtoInt(ComboBox1.Items[ComboBox1.ItemIndex]));
  ComboBox1.Hide;
  Button1.Hide;
  Image1.tag := 0; Image2.tag := 0; Image3.tag := 0; Image4.tag := 0; Image5.tag := 0; Image6.tag := 0;
  playtablegame.firstpodkid;
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
  for i := 1 to Length(end_mas) do
      end_mas[i].tag := 0;
  for i := 15 to 14 + Length(mas) do
      mas[i].tag := 0;
  j := 1;
  for i := 15 to 25 do begin
        if i mod 2 <> 0 then begin
           mas[i].Picture.LoadFromFile('img\' + inttostr(Tcard(playtablegame.guys[playtablegame.leaderindex].cards[j]).suit) +
           '_' + inttostr(Tcard(playtablegame.guys[playtablegame.leaderindex].cards[j]).number) + '.png');
            mas[i].tag := Tcard(playtablegame.guys[playtablegame.leaderindex].cards[j]).suit * 100 +
                       Tcard(playtablegame.guys[playtablegame.leaderindex].cards[j]).number;
            j := j + 1;
        end;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button3Click(Sender: TObject);//это кнопка забрать карты
var i, j : integer;
begin
  last_img := 0;
  playtablegame.take;
  for i := 1 to Length(end_mas) do begin
    if end_mas[i].tag <> 0 then begin
      for j := 15 to 40 do begin
          if (j mod 2 <> 0) and (mas[j].tag = 0) then begin
            mas[j].Picture.LoadFromFile('img\' + inttostr(end_mas[i].tag div 100) + '_' + inttostr(end_mas[i].tag mod 100) + '.png');
            mas[j].tag := end_mas[i].tag;
            end_mas[i].Picture := nil;
            end_mas[i].tag := 0;
            Label1.Caption := '';
          end;
      end;
    end;
  end;
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
  Constraints.MinHeight := 707;     // 525 840
  Constraints.MinWidth := 1680;
  Constraints.MaxHeight := 707;
  Constraints.MaxWidth := 1680;

  Form2 := TForm2.Create(Self);
  Form2.show;
end;

procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   draggg := False;
   mas[last_img].BeginDrag(False);
   last_img := 0;
end;

procedure TForm1.ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
begin

end;

procedure TForm1.ImageDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

end;

procedure TForm1.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   {if draggg then
     with img do begin
          setbounds(X + Form1.Left - width, Y + Form1.Top - height, Width, Height)
     end;        }
end;

procedure TForm1.ImageEndDrag(Sender, Target: TObject; X, Y: Integer);
var i : integer;
begin
   if last_img <> 0 then
   Label1.Caption := Label1.Caption + inttostr(mas[last_img].tag);
   for i := 1 to Length(end_mas) do
     if (MyMouse.CursorPos.x - Form1.Left >= end_mas[i].Left) and (last_img <> 0) and
           (MyMouse.CursorPos.x - Form1.Left <= end_mas[i].Width + end_mas[i].Left) and
           (MyMouse.CursorPos.y - Form1.Top >= end_mas[i].Top) and
           (MyMouse.CursorPos.y - Form1.Top <= end_mas[i].Top + end_mas[i].Height) then begin
        end_mas[i].Picture.LoadFromFile('img\' + inttostr(mas[last_img].tag div 100) + '_' + inttostr(mas[last_img].tag mod 100) + '.png');
        end_mas[i].tag := mas[last_img].tag;
        mas[last_img].Picture := nil;
        last_img := 0;
        draggg := False;
   end;
   if draggg then begin
      draggg := False;
      with mas[last_img] do
           setbounds(start_x, start_y, width, height);
      last_img := 0;
   end;
   mas[last_img].BeginDrag(False);
end;

procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mas[last_img].BeginDrag(True);
  draggg := True;
end;

procedure TForm1.ImageMouseEnter(Sender: TObject);
var i, j : integer;
begin
   last_img := 0;
   for i := 15 to 14 + Length(mas) do
       if  (MyMouse.CursorPos.x - Form1.Left >= mas[i].Left) and (mas[i].tag <> 0) and
           (MyMouse.CursorPos.x - Form1.Left <= mas[i].Width + mas[i].Left) and
           (MyMouse.CursorPos.y - Form1.Top >= mas[i].Top) and
           (MyMouse.CursorPos.y - Form1.Top <= mas[i].Top + mas[i].Height) then begin
           last_img := i;
           rec := mas[last_img].BoundsRect;
           start_x := mas[last_img].left;
           start_y := mas[last_img].top;
           with mas[last_img] do
                setbounds(rec.left, rec.top - 50, width, height);
       end;
end;

procedure TForm1.ImageMouseLeave(Sender: TObject);
begin
   if last_img <> 0 then begin
     rec := mas[last_img].BoundsRect;
     with mas[last_img] do
          setbounds(rec.left, Form1.Height - 36 - 87, width, height);
   end;
end;

end.

