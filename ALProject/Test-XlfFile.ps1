function Test-XlfFile{    
        Param (        
            [Parameter(Mandatory = $false)]            
            [Parameter(Mandatory = $true)]
            [string] $Path
        )
    if (-not (Test-Path $Path)){
        throw "'$Path' doesn' exist"
    }
    Write-Host "Validate $Path (XliffFile)"
    $xmlSchemaUrls = (Join-Path -Path ($PSScriptRoot) -ChildPath '..\xliff-core-1.2-transitional.xsd')   
    $settings = New-Object System.Xml.XmlReaderSettings
    $XmlSchemaUrls | ForEach-Object { $settings.Schemas.Add([System.Xml.Schema.XmlSchema]::Read([System.Xml.XmlReader]::Create($_), $null)) } | Out-Null
    $settings.ValidationType = 'Schema'
    $reader = [System.Xml.XmlReader]::Create($Path, $settings)
    $xmlInvalid = $false
    try {
        while ($reader.Read()) {}
    }
    catch {
        $errors = $_
        foreach ($innerException in $errors.Exception.InnerException) {                        
            Write-Host -Message $innerException.Message -Path $Path -LineNumber $innerException.LineNumber -ColumnNumber $innerException.LinePosition " ❌"
            $xmlInvalid = $true
        }
    }
    finally {
        $reader.Close()
    }

    try {  
        Add-Type -TypeDefinition @"  
        public class TransunitRecord  
        {  
            public string Id { get; set; }  
            public string Source { get; set; }  
            public string Target { get; set; }  
            public string State { get; set; }  
            public string Note { get; set; }  
            public string Message { get; set; }  
            public bool Valid { get; set; }  
        }  
    "@  
      
        $xliffGeneratorHashCode = "Xliff Generator".GetHashCode()  
      
        $xTargetUnitDict = @{}  
        $xDocument = [System.Xml.Linq.XDocument]::Load($filePath)  
        $ns = "urn:oasis:names:tc:xliff:document:1.2"  
        $xFile = $xDocument.Descendants() | Where-Object { $_.Name.LocalName -eq "file" } | Select-Object -First 1  
        $sourceLanguage = $xFile.Attribute("source-language").Value  
        $targetLanguage = $xFile.Attribute("target-language").Value  
        $IsSourceAndTargetMatching = $sourceLanguage -eq $targetLanguage  
      
        $InvalidCount = 0  
        $TransunitRecords = @()  
      
        $xDocument.Descendants() | Where-Object { $_.Name.LocalName -eq "trans-unit" } | ForEach-Object {  
            $xTransunitElement = $_  
            $xNote = $xTransunitElement.Elements($ns + "note") | Where-Object { $_.Attribute("from").Value.GetHashCode() -eq $xliffGeneratorHashCode } | Select-Object -First 1  
            $transUnit = New-Object TransunitRecord  
            $transUnit.Id = $xTransunitElement.Attribute("id").Value  
            $transUnit.Source = $xTransunitElement.Element($ns + "source").Value  
            $transUnit.Target = $xTransunitElement.Element($ns + "target").Value  
            $transUnit.State = $xTransunitElement.Element($ns + "target").Attribute("state").Value  
            $transUnit.Note = $xNote.Value  
            $TransunitRecords += $transUnit  
      
            $currentHashcode = $transUnit.GetHashCode()  
            if (!$xTargetUnitDict.ContainsKey($currentHashcode)) {  
                $xTargetUnitDict.Add($currentHashcode, $transUnit)  
            } else {  
                $xAlreadyHandledTargetUnid = $xTargetUnitDict[$currentHashcode]  
                if ($xAlreadyHandledTargetUnid.Message) { $xAlreadyHandledTargetUnid.Message += ", " }  
                $xAlreadyHandledTargetUnid.Valid = $false  
                $xAlreadyHandledTargetUnid.Message += "Diese Target-Unit-Id wird mehrfach verwendet"  
                $InvalidCount++  
      
                if ($transUnit.Message) { $transUnit.Message += ", " }  
                $transUnit.Valid = $xAlreadyHandledTargetUnid.Valid  
                $transUnit.Message += $xAlreadyHandledTargetUnid.Message  
            }  
      
            # ... rest of your code  
        }  
        # ... rest of your code  
    } catch {  
        Write-Host "Exception: $($_.Exception.Message)"  
    }  

    # try {
        
    #     $xTargetUnitDict = @{}
    #     [xml]$xDocument = Get-Content -Path $filePath
    #     $ns = New-Object System.Xml.XmlNamespaceManager $xDocument.NameTable
    #     $ns.AddNamespace('ns', 'urn:oasis:names:tc:xliff:document:1.2')
    #     $xFile = $xDocument.SelectSingleNode('//ns:file', $ns)
    #     $sourceLanguage = $xFile.GetAttribute("source-language")
    #     $targetLanguage = $xFile.GetAttribute("target-language")
    #     $IsSourceAndTargetMatching = $sourceLanguage -eq $targetLanguage
    #     $xTransunitElementList = $xDocument.SelectNodes('//ns:trans-unit', $ns)
    #     foreach ($xTransunitElement in $xTransunitElementList) {
    #         # Rest of your code
    #     }
    #     # More of your code
    # }
    # catch {
    #     Write-Host $_.Exception.Message
    # }

    # try
    # {
    #     var xliffGeneratorHashCode = "Xliff Generator".GetHashCode();

    #     var xTargetUnitDict = new Dictionary<int, TransunitRecord>();
    #     var xDocument = XDocument.Load(filePath);
    #     XNamespace ns = "urn:oasis:names:tc:xliff:document:1.2";
    #     var xFile = xDocument.Descendants().First(d => d.Name == ns + "file");
    #     var sourceLanguage = xFile.Attribute("source-language")?.Value;
    #     var targetLanguage = xFile.Attribute("target-language")?.Value;
    #     var IsSourceAndTargetMatching = sourceLanguage == targetLanguage;
    #     foreach (XElement xTransunitElement in xDocument.Descendants().Where(d => d.Name == ns + "trans-unit"))
    #     {
    #         var xNote = xTransunitElement.Elements(ns + "note").Where(n => n.Attribute("from")?.Value.GetHashCode() == xliffGeneratorHashCode).First();
    #         var transUnit = new TransunitRecord()
    #         {
    #             Id = xTransunitElement.Attribute("id")?.Value,
    #             Source = xTransunitElement.Element(ns + "source")?.Value,
    #             Target = IsSourceAndTargetMatching ? null : xTransunitElement.Element(ns + "target")?.Value,
    #             State = IsSourceAndTargetMatching ? null : xTransunitElement.Element(ns + "target")?.Attribute("state")?.Value,
    #             Note = xNote.Value
    #         };
    #         TransunitRecords.Add(transUnit);
    #         var currentHashcode = transUnit.GetHashCode();
    #         if (!xTargetUnitDict.ContainsKey(currentHashcode))
    #         {
    #             xTargetUnitDict.Add(currentHashcode, transUnit);
    #         }
    #         else
    #         {
    #             var xAlreadyHandledTargetUnid = xTargetUnitDict[currentHashcode];
    #             if (xAlreadyHandledTargetUnid.Message != null)
    #                 xAlreadyHandledTargetUnid.Message += ", ";
    #             xAlreadyHandledTargetUnid.Valid = false;
    #             xAlreadyHandledTargetUnid.Message += "Diese Target-Unit-Id wird mehrfach verwendet";
    #             InvalidCount++;

    #             if (transUnit.Message != null)
    #                 transUnit.Message += ", ";
    #             transUnit.Valid = xAlreadyHandledTargetUnid.Valid;
    #             transUnit.Message += xAlreadyHandledTargetUnid.Message;
    #         }

    #         var sourceCount = xTransunitElement.Elements(ns + "source").Count();
    #         if (sourceCount > 1) 
    #         {
    #             if (transUnit.Message != null)
    #                 transUnit.Message += ", ";
    #             transUnit.Valid = false;
    #             transUnit.Message += $"{sourceCount} source elemente gefunden";
    #         }

    #         var targetCount = xTransunitElement.Elements(ns + "target").Count();
    #         if (targetCount > 1)
    #         {
    #             if (transUnit.Message != null)
    #                 transUnit.Message += ", ";
    #             transUnit.Valid = false;
    #             transUnit.Message += $"{targetCount} target elemente gefunden";
    #         }

    #         if (transUnit.Source == null)
    #         {
    #             if (transUnit.Message != null)
    #                 transUnit.Message += ", ";
    #             transUnit.Valid = false;
    #             transUnit.Message += "Source element fehlt";
    #         }

    #         if (IsSourceAndTargetMatching)
    #             continue;

    #         if (transUnit.Target == null)
    #         {
    #             if (transUnit.Message != null)
    #                 transUnit.Message += ", ";
    #             transUnit.Valid = false;
    #             transUnit.Message += "Target element fehlt";
    #         }

    #         switch (transUnit.State)
    #         {
    #             case "new":
    #             case "needs-review-translation":
    #                 {
    #                     if (transUnit.Message != null)
    #                         transUnit.Message += ", ";
    #                     transUnit.Valid = false;
    #                     transUnit.Message += $"Zustand ist '{transUnit.State}'";
    #                     break;
    #                 }
    #             case "final":
    #             case "translated":
    #                 {
    #                     break;
    #                 }
    #             default:
    #                 {
    #                     if (transUnit.Message != null)
    #                         transUnit.Message += ", ";
    #                     transUnit.Valid = false;
    #                     transUnit.Message += $"Unbekannter State'{transUnit.State}'";
    #                     break;
    #                 }
    #         }

    #         if (String.IsNullOrWhiteSpace(transUnit.Source) && !String.IsNullOrWhiteSpace(transUnit.Target))
    #         {
    #             if (transUnit.Message != null)
    #                 transUnit.Message += ", ";
    #             transUnit.Valid = false;
    #             transUnit.Message += $"Source ist leer";
    #         }

    #         if (!String.IsNullOrWhiteSpace(transUnit.Source) && String.IsNullOrWhiteSpace(transUnit.Target))
    #         {
    #             if (transUnit.Message != null)
    #                 transUnit.Message += ", ";
    #             transUnit.Valid = false;
    #             transUnit.Message += $"Target ist leer";
    #         }
    #     }
    #     InvalidCount = TransunitRecords.Count(t => !t.Valid);
    #     ReadFinished(this, new EventArgs());
    # }
    # catch (Exception ex)
    # {
    #     MessageBox.Show(ex.Message, "Exception", MessageBoxButton.OK, MessageBoxImage.Error, MessageBoxResult.OK);
    # }

    

    # return (-not $xmlInvalid)
}