unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ActnList
  , Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Action1: TAction;
    ActionList1: TActionList;
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
    procedure Action1Update(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image17Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FindCard(suit, num : integer; List : TList; var res : TCard);
    procedure CoverImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MastoEndmas;
    procedure UpdateCards;
    procedure ShowHideButtons (condition : integer);
  private
    flag : boolean;
    //images : array [1..6] of Timage;
    playtablegame : Tplaytable;
    distribution : boolean;
    mas : array[15..40] of TImage;
    distributioncard : TImage;
    end_mas : array[1..6] of TImage;
    cover_mas : array[1..6] of TImage;
    //move: boolean;
    cover_img, last_img: integer;

  public
  end;

var
  Form1: TForm1;

implementation
{$R *.lfm}

uses
  Unit3;


procedure TForm1.UpdateCards;
var i : integer;
begin
  for i := 0 to playtablegame.card6.Count-1 do begin
    end_mas[i+1].Picture.LoadFromFile('img\' + inttostr(tcard(playtablegame.card6[i]).suit) + '_' + inttostr(tcard(playtablegame.card6[i]).number) + '.png');
    end_mas[i+1].tag := tcard(playtablegame.card6[i]).suit * 100 + tcard(playtablegame.card6[i]).number;
  end;
  for i := 0 to 5 do begin
      cover_mas[i+1].Picture.Clear;
      cover_mas[i+1].Tag:=0;
  end;
  for i := 0 to playtablegame.covercard6.Count-1 do begin
    if (playtablegame.covercard6[i] <> nil) then begin
      cover_mas[i+1].Picture.LoadFromFile('img\' + inttostr(tcard(playtablegame.covercard6[i]).suit) + '_' + inttostr(tcard(playtablegame.covercard6[i]).number) + '.png');
      cover_mas[i+1].tag := tcard(playtablegame.covercard6[i]).suit * 100 + tcard(playtablegame.covercard6[i]).number;
    end;
  end;

  for i := playtablegame.card6.Count to 5 do begin
     end_mas[i+1].Picture.Clear;
     end_mas[i+1].Tag:=0;
  end;
  distribution := playtablegame.arrayofallcards.Count > 0;
  distribution := true;
  if distribution then begin
    distributioncard.Picture.LoadFromFile('img\tshirt.png');
  end;
  for i := 0 to tguy(playtablegame.guys[0]).cards.Count-1 do begin
    mas[i+15].Picture.LoadFromFile('img\' + inttostr(tcard(tguy(playtablegame.guys[0]).cards[i]).suit) + '_' + inttostr(tcard(tguy(playtablegame.guys[0]).cards[i]).number) + '.png');
    mas[i+15].tag := tcard(tguy(playtablegame.guys[0]).cards[i]).suit * 100 + tcard(tguy(playtablegame.guys[0]).cards[i]).number;
  end;
  for i := tguy(playtablegame.guys[0]).cards.Count to 40-15 do begin
    mas[i+15].Picture.Clear;
    mas[i+15].Tag:=0;
  end;
end;

procedure TForm1.ShowHideButtons (condition : integer);
var b : boolean;
begin
  if condition = 1 then begin
    button3.Enabled := false;//взять
    button4.Enabled := false;//перевести
    button5.Enabled := false;//покрыть
    button6.Enabled := false;//сходить
  end
  else if condition = 2 then begin
    button3.Enabled := true;
    button4.Enabled := false;
    button5.Enabled := true;
    button6.Enabled := false;
  end
  else if condition = 3 then begin
    button3.Enabled := false;
    button4.Enabled := true;
    button5.Enabled := false;
    button6.Enabled := true;
  end
  else if condition = 4 then begin
    button3.Enabled := false;
    button4.Enabled := false;
    button5.Enabled := false;
    button6.Enabled := false;
  end
  else if condition = 5 then begin
    button3.Enabled := true;
    button4.Enabled := true;
    button5.Enabled := true;
    button6.Enabled := false;
  end
  else if condition = 6 then begin
    playtablegame.cantransfer(b);
    button4.Enabled := b;
    button6.Enabled := b;
    button3.Show;
    if tguy(playtablegame.guys[0]).cards.Count > 0 then button5.Show;
  end
  else if condition = 7 then begin
    button3.Enabled := true;
    button4.Enabled := false;
    button5.Enabled := false;
    button6.Enabled := false;
  end
  else if condition = 8 then begin
    button3.Enabled := true;
    button4.Enabled := true;
    button5.Enabled := false;
    button6.Enabled := false;
  end;
  if tguy(playtablegame.guys[0]).b5 = 1 then button5.Enabled := true else  if tguy(playtablegame.guys[0]).b5 = 0 then  button5.Enabled := false;  //для локальных настроек
  if tguy(playtablegame.guys[0]).b4 = 1 then button4.Enabled := true else if tguy(playtablegame.guys[0]).b4 = 0 then button4.Enabled := false;
  if tguy(playtablegame.guys[0]).b3 = 1 then button3.Enabled := true else if tguy(playtablegame.guys[0]).b3 = 0 then button3.Enabled := false;
  if tguy(playtablegame.guys[0]).b6 = 1 then button6.Enabled := true else if tguy(playtablegame.guys[0]).b6 = 0 then  button6.Enabled := false;
  if tguy(playtablegame.guys[0]).b7 = 1 then button7.Enabled := true else  if tguy(playtablegame.guys[0]).b7 = 0 then  button7.Enabled := false;
  tguy(playtablegame.guys[0]).b5 := -1;
  tguy(playtablegame.guys[0]).b4 := -1;
  tguy(playtablegame.guys[0]).b3 := -1;
  tguy(playtablegame.guys[0]).b6 := -1;
  tguy(playtablegame.guys[0]).b7 := -1;
end;

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
  Button5.Visible := True;
  last_img := 0;
  Button6.Visible := True;
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
  distributioncard := Image7;
  for i := 1 to Length(end_mas) do
      end_mas[i].tag := 0;
  for i := 1 to Length(cover_mas) do
      cover_mas[i].tag := 0;
  for i := Low(mas) to High(mas) do
      mas[i].tag := 0;
  j := 0;
  for j := 0 to playtablegame.playerCardsCount - 1 do begin
      i := 15 + j * 2;
      mas[i].Picture.LoadFromFile('img\' + inttostr(playtablegame.playerCards[j].suit) +'_' + inttostr(playtablegame.playerCards[j].number) + '.png');
      mas[i].tag := playtablegame.playerCards[j].suit * 100 + playtablegame.playerCards[j].number;
   end;
  playtablegame.systemofchoosingcard;
  UpdateCards;
  for i := 0 to Tguy(playtablegame.guys[0]).cards.Count-1 do
    Form2.Memo1.Lines.Append('карта защищающегося ' + IntToStr(Tcard((Tguy(playtablegame.guys[0])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(playtablegame.guys[0])).cards[i]).suit));
  ShowHideButtons(playtablegame.takecondition);
  Form2.Memo1.Lines.Append('led button1 - ' + inttostr(playtablegame.leaderindex));
  Form2.Memo1.Lines.Append('козырная - '+ inttostr(playtablegame.supercard) + '  (1 - красные сердечки, 2 - черные сердечки, 3 - красная оставшаяся фигура, 4 - черная оставшаяся фигура )');
end;

procedure TForm1.Action1Update(Sender: TObject);
var L, j : integer;
  b : boolean;
begin
  {b := false;
  L := Tcard(playtablegame.card6[0]).number;
  for j := 0 to tguy(playtablegame.guys[nextleaderindex]).cards.Count-1  do
    if Tcard(tguy(playtablegame.guys[nextleaderindex]).cards[j]).number = L then b := true;
  //action1.enabled := playtablegame.}
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button3Click(Sender: TObject);//взять
var c : integer;
begin
  Form2.Memo1.Lines.Append('led button - ' + inttostr(playtablegame.leaderindex));
  last_img := 0;
  cover_img := 0;
  playtablegame.take;

  ShowHideButtons(playtablegame.takecondition);
  UpdateCards;
end;

procedure TForm1.Button4Click(Sender: TObject);   //перевести
var card : Tcard;
    g : Tguy;
    nextleaderindex : integer;
    x, b : boolean;
begin
  if last_img <> 0 then begin
    nextleaderindex := (playtablegame.leaderindex + 1) mod playtablegame.guys.Count;

    g := Tguy(playtablegame.guys[0]);

    Form2.Memo1.Lines.Append(inttostr(last_img));
    FindCard(mas[last_img].tag div 100, mas[last_img].tag mod 100 , tguy(playtablegame.guys[nextleaderindex]).cards, card);
    playtablegame.switchdefender(card, x);
      {k := 0;
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
         end;}
    UpdateCards;
    playtablegame.canTransfer (b);
    ShowHideButtons(playtablegame.takecondition);
    Form2.Memo1.Lines.Append('лидериндекс    -     '+ inttostr(playtablegame.leaderindex));

  end;
end;

procedure TForm1.FindCard(suit, num : integer; List : TList; var res : TCard);
var i : integer;
begin
  res := nil;
  //nextleaderindex := (playtablegame.leaderindex + 1) mod playtablegame.guys.Count;
  for i := 0 to List.Count - 1 do begin
     if (suit = TCard(List[i]).suit) and (num = TCard(List[i]).number) then begin
          //Form2.Memo1.Lines.Append(inttostr(TCard(List[i]).number));
          //Form2.Memo1.Lines.Append(inttostr(TCard(List[i]).suit));
          res := TCard(List[i]);

     end;
  end;
end;


procedure TForm1.Button5Click(Sender: TObject); //покрыть
var CardFromInventory, OnTableCard : Tcard;
    bool, d : boolean;
    nextleaderindex , i : integer;
    g : Tlist;
begin
  Form2.Memo1.Lines.Append('лидериндекс    -     '+ inttostr(playtablegame.leaderindex));
  if (last_img <> 0) and (cover_img <> 0) then begin //проверка что карты выбраны
    nextleaderindex := (playtablegame.leaderindex + 1) mod playtablegame.guys.Count;
    g := Tguy(playtablegame.guys[nextleaderindex]).cards;
    FindCard(mas[last_img].tag div 100, mas[last_img].tag mod 100, g , CardFromInventory);
    FindCard(end_mas[cover_img].tag div 100, end_mas[cover_img].tag mod 100, playtablegame.card6, OnTableCard);
    bool := false;
    d := false;
    if CardFromInventory <> nil then playtablegame.covercards(CardFromInventory, OnTableCard, bool);
    if bool then begin //если просто может покрыть тогда
      playtablegame.canplayercover (d);//сможет ли чел еще покрывать
      Form2.Memo1.Lines.Append('d = ' + booltostr(d));
      if d then begin
        ShowHideButtons(2);
      end
      else if not d then begin
        ShowHideButtons (7);
      end;
      cover_mas[cover_img].Picture.LoadFromFile('img\' + inttostr(mas[last_img].tag div 100) + '_' + inttostr(mas[last_img].tag mod 100) + '.png');
      cover_mas[cover_img].tag := mas[last_img].tag;
      // mas[last_img].Picture := nil;
      //mas[last_img].tag := 0;
      last_img := 0;
      cover_img := 0;
      //Shape1.Visible := False;
      //Shape2.Visible := False;
    end;
    d := false;
    //playtablegame.canplayercover (d);
    Form2.Memo1.Lines.Append(booltostr(d));

    //else if (playtablegame.card6.Count = 0)then begin
        //ShowHideButtons (1)
      //end;
  end;
  Form2.Memo1.Lines.Append('лидериндекс    -     '+ inttostr(playtablegame.leaderindex));
  Updatecards;
  for i := 0 to Tguy(playtablegame.guys[0]).cards.Count-1 do
    Form2.Memo1.Lines.Append('карта защищающегося ' + IntToStr(Tcard((Tguy(playtablegame.guys[0])).cards[i]).number) + ' ' + IntToStr(Tcard((Tguy(playtablegame.guys[0])).cards[i]).suit));
end;


procedure TForm1.Button7Click(Sender: TObject); //сходить
var i : integer;
    stop : boolean;
begin
  //MasToEndmas;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  ShowHideButtons(4);
  playtablegame.changeofleaderindex;
end;


procedure TForm1.FormCreate (Sender: TObject);
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
  button5.Hide;
  button6.Hide;
end;

procedure TForm1.Image17Click(Sender: TObject);
begin

end;

procedure TForm1.Image1Click(Sender: TObject);
begin

end;

procedure TForm1.Image4Click(Sender: TObject);
begin

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

procedure TForm1.CoverImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i : integer;
begin
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
