unit RstrFld;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Forms, ExtCtrls;

type

  { TRasterFeld }
  TRasterFeld = class
  private
    { private delcarations }
    fRasterGroesse, fFeldBreite, fFeldHoehe: integer;
    fMinX, fMinY, fMaxX, fMaxY: integer;
    fCanvas: TCanvas;
    fForm: TForm;
    fHintergrund: TColor;
    fInterval: integer;
    fSpielSchleife: TTimer;
    fSpielSchleifeAn: boolean;
    fRenderSchleife: TTimer;
    fRenderSchleifeAn: boolean;
    fMitte: boolean;
    procedure SetMitte(Mitte: boolean);
    procedure SetInterval(Interval: integer);
    procedure SetFeldBreite(FeldBreite: integer);
    procedure SetFeldHoehe(FeldHoehe: integer);
    procedure PrivateRenderSchleife(Sender: TObject);
  public
    { public declarations }
    constructor Erstelle(RasterGroesse, FeldBreite, FeldHoehe: integer; Form1: TForm);
    procedure Loeschen();
    procedure Rechteck(X, Y: integer; Farbe: TColor);
    procedure Rechteck(X, Y: integer);
    procedure StarteSpielSchleife(Interval: integer; EventHandler: TNotifyEvent);
    procedure StoppeSpielSchleife();
    procedure StarteRenderSchleife();
    procedure StoppeRenderSchleife();
    procedure FormAnFeldAnpassen();

    property FeldBreite: integer read fFeldBreite write SetFeldBreite;
    property FeldHoehe: integer read fFeldHoehe write SetFeldHoehe;
    property RasterGroesse: integer read fRasterGroesse;
    property HintergrundFarbe: TColor read fHintergrund write fHintergrund;
    property Interval: integer read fInterval write SetInterval;
    property Mitte: boolean read fMitte write SetMitte;
  end;

implementation



// Diese Funktion erstellt und zeichnet ein neues Rasterfeld mit den angegeben Parametern
constructor TRasterFeld.Erstelle(RasterGroesse, FeldBreite, FeldHoehe: integer; Form1: TForm);
begin

  // Felder für das Rasterfeld setzen
  fRasterGroesse := RasterGroesse;
  fFeldBreite := FeldBreite;
  fFeldHoehe := FeldHoehe;
  fCanvas := Form1.Canvas;
  fForm := Form1;
  fHintergrund := clBlack;

  SetMitte(true);
end;



// Private Funktion
procedure TRasterFeld.SetMitte(Mitte: boolean);
var MitteX, MitteY: integer;
begin
  fMitte := Mitte;

  if fMitte then begin
    // Berechnung des Mittelpunkts der Form
    MitteX := fForm.Width div 2;
    MitteY := fForm.Height div 2;

    // Berechung der Start- und End-Positionen für das Rasterfeld
    fMinX := MitteX - ((fFeldBreite * fRasterGroesse) div 2);
    fMinY := MitteY - ((fFeldHoehe * fRasterGroesse) div 2);

    fMaxX := fMinX + (fFeldBreite * fRasterGroesse);
    fMaxY := fMinY + (fFeldHoehe * fRasterGroesse);
  end else begin
    fMinX := 0;
    fMinY := 0;

    fMaxX := fFeldBreite * fRasterGroesse;
    fMaxY := fFeldHoehe * fRasterGroesse;
  end;
end;



// Private Funktion
procedure TRasterFeld.SetFeldBreite(FeldBreite: integer);
begin
  fFeldBreite := FeldBreite;
  SetMitte(fMitte);
end;



// Private Funktion
procedure TRasterFeld.SetFeldHoehe(FeldHoehe: integer);
begin
  fFeldHoehe := FeldHoehe;
  SetMitte(fMitte);
end;



// Diese Funktion passt die Größe des Forms an die Größe des Raster-Feldes an,
// sodass man nur noch das ganze Raster-Feld sieht
procedure TRasterFeld.FormAnFeldAnpassen();
begin
  // Groesse des Forms an die Groesse des Rasterfeldes anpassen
  fForm.Width := fFeldBreite * fRasterGroesse;
  fForm.Height := fFeldHoehe * fRasterGroesse;

  // Start- und End-Positionen setzen
  fMinX := 0;
  fMinY := 0;
  fMaxX := fForm.Width;
  fMaxY := fForm.Height;
end;



// Diese Funktion löscht alle Rechtecke auf dem Raster-Feld
procedure TRasterFeld.Loeschen();
begin

  // Zeichnen des Rasterfeldes
  fCanvas.Brush.Color := fHintergrund;
  fCanvas.FillRect(fMinX, fMinY, fMaxX, fMaxY);

end;



// Diese Funktion erstellt ein Rechteck mit der angegebenden Farbe
// an der X und Y Position des Raster-Feldes
procedure TRasterFeld.Rechteck(X, Y: integer; Farbe: TColor);
var RasterX, RasterY, RasterMaxX, RasterMaxY: integer;
begin


  if X >= fFeldBreite then Exit;
  if Y >= fFeldHoehe then Exit;

  // Berechnung der Raster Position
  RasterX := fMinX + (X * fRasterGroesse);
  RasterY := fMinY + (Y * fRasterGroesse);

  // Farbe für das Raster setzen
  fCanvas.Brush.Color := Farbe;

  // Zeichnung des Rasters
  inc(RasterX);
  inc(RasterY);
  RasterMaxX := RasterX + fRasterGroesse - 2;
  RasterMaxY := RasterY + fRasterGroesse - 2;
  fCanvas.FillRect(RasterX, RasterY, RasterMaxX, RasterMaxY);

end;



// Diese Funktion erstellt ein weißes Rechteck
// an der X und Y Position des Raster-Feldes
procedure TRasterFeld.Rechteck(X, Y: integer);
begin
  Rechteck(X, Y, clWhite);
end;



// Diese Funktion startet einen Timer, welcher den EventHandler in dem
// angegebenen Interval wiederholt ausführt
procedure TRasterFeld.StarteSpielSchleife(Interval: integer; EventHandler: TNotifyEvent);
begin
  fSpielSchleife := TTimer.Create(fForm);
  fSpielSchleife.Interval := Interval;
  fSpielSchleife.OnTimer := EventHandler;
  fInterval := Interval;
  fSpielSchleifeAn := true;
end;



// Diese Funktion stoppt die Spielschleife
procedure TRasterFeld.StoppeSpielSchleife();
begin
  if fSpielSchleifeAn then begin
    fSpielSchleife.Enabled := false;
    FreeAndNil(fSpielSchleife);
    fSpielSchleifeAn := false;
  end;
end;



// Diese Funktion startet die Renderschleife
procedure TRasterFeld.StarteRenderSchleife();
begin
  fRenderSchleife := TTimer.Create(fForm);
  fRenderSchleife.Interval := 1000 div 60; // 60 fps
  fRenderSchleife.OnTimer := @PrivateRenderSchleife;
  fRenderSchleifeAn := true;
end;



// Diese Funktion stoppt die Renderschleife
procedure TRasterFeld.StoppeRenderSchleife();
begin
  if fRenderSchleifeAn then begin
    fRenderSchleife.Enabled := false;
    FreeAndNil(fRenderSchleife);
    fRenderSchleifeAn := false;
  end;
end;



// Private Funktion
procedure TRasterFeld.PrivateRenderSchleife(Sender: TObject);
begin
  fForm.Refresh;
end;



// Private Funktion
procedure TRasterFeld.SetInterval(Interval: integer);
begin
  fSpielSchleife.Interval := Interval;
  fInterval := Interval;
end;



end.
