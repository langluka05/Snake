unit snake;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, RstrFld;
type
  TSnake = class
  private
    fX, fY : integer;
    fColor : TColor;
    fFeld : TRasterFeld;

  public
    constructor Create(X, Y : integer; Farbe : TColor; Feld : TRasterFeld);

    procedure Bewegung(richtung : String);
    procedure Rendern();
    property X: integer read fX write fX;
    property Y: integer read fY write fY;
    property Farbe : TColor read fColor;
  end;

implementation

constructor TSnake.Create(X, Y : integer; Farbe : TColor; Feld : TRasterFeld);
begin
  fX := X;
  fY := Y;
  fColor := Farbe;
  fFeld := Feld;
end;

procedure TSnake.Rendern();
begin
  fFeld.Rechteck(fX, fY, fColor);
end;

procedure TSnake.Bewegung(richtung : String);
begin
  if richtung = 'rechts' then
     inc(fX)
  else if richtung = 'links' then
     dec(fX)
  else if richtung = 'hoch' then
     dec(fY)
  else if richtung = 'runter' then
     inc(fY);
end;

end.

