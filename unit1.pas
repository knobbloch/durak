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
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    images : array [1..6] of Timage;
    guys : array [1..7] of Tguy;
    remainingcard: integer;
    supercard : integer;
    playtablegame : Tplaytable;
    bito : boolean;//рисовать текстуру сыгранных карт или нет
  public
  end;

var
  Form1: TForm1;

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
  remainingcard := 51;
  {images[1] := Image15;
  images[2] := Image16;
  images[3] := Image17;
  images[4] := Image18;
  images[5] := Image19;
  images[6] := Image20;
   for j := 1 to 6 do begin
         images[j].Picture.LoadFromFile('img\' + inttostr(guys[i].cards[j].suit) + '_' + inttostr(guys[i].cards[j].number) + '.png');}

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  close;
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
  Constraints.MinHeight := 525;
  Constraints.MinWidth := 840;
  Constraints.MaxHeight := 525;
  Constraints.MaxWidth := 840;

  Form2 := TForm2.Create(Self);
  Form2.show;
end;

end.

