program DomProirix;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrinc in 'UPrinc.pas' {FPrinc};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape];
  Application.CreateForm(TFPrinc, FPrinc);
  Application.Run;
end.
