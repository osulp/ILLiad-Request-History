interfaceMngr = nil;
requestCountForm = {};
requestCountForm.Form = nil;
requestCountForm.Grid = nil;
requestCountForm.TextEdit = nil;
requestCountForm.RibbonPage = nil;
connection = nil;

function Init()
	connection = CreateManagedDatabaseConnection();
	connection:Connect();
	interfaceMngr = GetInterfaceManager();
	requestCountForm.Form = interfaceMngr:CreateForm("RequestCount", "Script");
	requestCountForm.RibbonPage = requestCountForm.Form:CreateRibbonPage("Request Count");
	requestCountForm.TextEdit = requestCountForm.Form:CreateTextEdit("Count", "Number of Similar Requests");
	requestCountForm.TextEdit.ReadOnly = true;
	requestCountForm.TextEdit.Value = GetCount();
	requestCountForm.Grid = requestCountForm.Form:CreateGrid("History", "History");
	requestCountForm.Grid.PrimaryTable = GetHistory();
	requestCountForm.Form:Show();
	connection:Dispose();
end

function GetCount()
	connection.QueryString = GetQuery('COUNT(*)');
	return connection:ExecuteScalar();
end

function GetQuery(fields)
	return "SELECT "..fields.." FROM transactions WHERE ((ISSN = '"..ISSN().."' AND ISSN != '') OR (ESPNumber = '"..ESPNumber().."' AND ESPNumber IS NOT NULL AND ESPNumber != '')) AND TransactionNumber != '"..TransactionNumber().."'";
end

function GetHistory()
	connection.QueryString = GetQuery('*');
	return connection:Execute();
end

function ISSN()
	return GetFieldValue("Transaction", "ISSN");
end

function ESPNumber()
	return GetFieldValue("Transaction", "ESPNumber");
end

function TransactionNumber()
	return GetFieldValue("Transaction", "TransactionNumber");
end