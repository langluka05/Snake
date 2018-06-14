unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  RstrFld, snake;

type

  { TForm1 }

  TForm1 = class(TForm)
    BRasterFeld: TButton;
    procedure BRasterFeldClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SpielSchleife(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end;


var
  Form1: TForm1;
  SpielFeld: TRasterFeld;
  KastenX, KastenY: integer;
  Rendern: boolean;
  Schlange: TSnake;

implementation

{$R *.lfm}

{ TForm1 }



// Prozedur wird aufgerufen, sobald der Button gedrückt wird
procedure TForm1.BRasterFeldClick(Sender: TObject);
begin
  BRasterFeld.Visible := false;  // Den Button nicht sichtbar machen

  SpielFeld := TRasterFeld.Erstelle(50, 12, 9, Self); // Das RasterFeld erstellen
  SpielFeld.FormAnFeldAnpassen();  // Die Größe der Form an die Größe des RasterFeldes anpassen
  SpielFeld.StarteSpielSchleife(1000 div 2, @SpielSchleife); // Startet die Spiel Schleife mit 2 Aufrufen pro Sekunden
  SpielFeld.StarteRenderSchleife(); // Startet die Render Schleife mit 60 fps

  Rendern := True;

  Schlange := TSnake.Create(0, 0, clRed, SpielFeld);

end;


var Runter: boolean;

// Prozedur entspricht der Spiel Schleife und wird 2 Mal in einer Sekunde aufgerufen
procedure TForm1.SpielSchleife(Sender: TObject);
begin

  //KastenX := 200;//Random(SpielFeld.FeldBreite);
  //KastenY := 200;//Random(SpielFeld.FeldHoehe);
  if(Runter) then Schlange.Bewegung('runter')
  else Schlange.Bewegung('rechts');

  Runter := not Runter;
end;



// In dieser Prozedur wird alles gerendert mit 60 fps
procedure TForm1.FormPaint(Sender: TObject);
begin
  if not Rendern then Exit; // Erst anfangen zu Rendern wenn der Button geklickt wurde

  SpielFeld.Loeschen();
  Schlange.Rendern();

end;

// Prozedur wird aufgerufen, sobald das Fenster geschlossen wird
procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SpielFeld.StoppeSpielSchleife();
  SpielFeld.StoppeRenderSchleife();
  FreeAndNil(SpielFeld); // SpielFeld-Objekt aus dem Speicher (RAM) löschen
end;

end.

