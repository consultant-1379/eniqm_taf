package Test_Report;
use Result;

$"="\n";
sub Print_Result()
{

my	$Format='<html>
<head>
<title> ENIQ-M Test suite Result </title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
<script type="text/javascript">

$(window).load(function(){
 $("dd").hide();
    $(\'dt\').click(function(){
                var dl = $(this).parent();
				$(this).next("dd").slideToggle();
                //$(\'dd\',dl).slideToggle();
    });
});          
</script>
</head>

<body bgcolor="#BAA0A0">
<h1 align="center"><u><i>ENIQ-M Test suite Result </i></u></h1>';

my $Executed=shift;
my $passed=shift;
my $Failed=shift;
my $Total_Time=shift;
my $SMOKE_ref=shift;
my $SNMP_ref=shift;
my $UTRAN_ref=shift;
my $LTE_ref=shift;
my $TSS_ref=shift;
my $CORE_ref=shift;
my $GRAN_ref=shift;
my $OSS_Installed=shift;
my $System_Revision=shift;
my $REV=shift;
my $Rstate=shift;
my @TC_SMOKE_Details=@$SMOKE_ref;
my @TC_SNMP_Details=@$SNMP_ref;
my @TC_UTRAN_Details=@$UTRAN_ref;
my @TC_LTE_Details=@$LTE_ref;
my @TC_TSS_Details=@$TSS_ref;
my @TC_CORE_Details=@$CORE_ref;
my @TC_GRAN_Details=@$GRAN_ref;

#Opening testlog file
	open (OUTPUT ,">$RESULT_FILE") or $EXIT_CODE=10,die "$!";
	print OUTPUT "$Format";
	print OUTPUT "<table border = \"1\" bgcolor=\"#FFFFFF\" cellpadding=\"5\" cellspacing=\"5\" align=\"center\">
<caption><h2>TEST ENVIRONMENT</h2></caption>
<tr><td bgcolor=\"#C0C0C0\"><b>OSS Installed : </b></td><td bgcolor=\"#C0C0C0\">$OSS_Installed REV: $REV</td></tr>
<tr><td bgcolor=\"#C0C0C0\"><b>System Revision : </b></td><td bgcolor=\"#C0C0C0\">$System_Revision</td></tr>
<tr><td bgcolor=\"#C0C0C0\"><b>ENIQ-M package R-state : </b></td><td bgcolor=\"#C0C0C0\">$Rstate</td></tr>
</table><br>";
	print OUTPUT '<table border = "1" bgcolor="#FFFFFF" cellpadding="5" cellspacing="5" align="center">
	<caption><h2>Result Detail</h2></caption>';
	print OUTPUT "<tr><td bgcolor=\"#C0C0C0\"><b>Total Test Cases Executed</b></td><td bgcolor=\"#C0C0C0\">$Executed</td></tr>";
	print OUTPUT "<tr><td bgcolor=\"#C0C0C0\"><b>Total Test Cases passed</b></td><td bgcolor=\"#C0C0C0\">$passed</td></tr>";
	print OUTPUT "<tr><td bgcolor=\"#C0C0C0\"><b>Total Test Cases Failed</b></td><td bgcolor=\"#C0C0C0\">$Failed</td></tr>";
	print OUTPUT "<tr><td bgcolor=\"#C0C0C0\"><b>Total Time Taken (hh:mm:ss:ms)</b></td><td bgcolor=\"#C0C0C0\">$Total_Time</td></tr>";
	print OUTPUT "</table>";
	print OUTPUT "<br>";
	print OUTPUT '<caption><h2 align="center">Executed Test Case Details</h2></caption>';
	print OUTPUT '<marquee behavior="alternate"><b>Please Click On Test Catagory Name For More Detail</b></marquee>';
	print OUTPUT '<table border = "1" bgcolor="#FFFFFF" bordercolor="#BDBDBD" cellpadding="5" cellspacing="5" align="center">
	<th bgcolor="#C0C0C0">Test Case Catagory<br>============================================================================================</th>';
	#######################################
	# printing Smoke test case result
	print OUTPUT '<tr><td bgcolor="#BDBDBD" ><b>
	<dl >
	<dt>
	<b>* Smoke Test Cases >>></b>
	</dt>
	<dd >
	<br>
	<table border="1" bgcolor="#FFFFFF" cellpadding="3" cellspacing="3" align="center">
	<th bgcolor="#C0C0C0">Test Case ID</th><th bgcolor="#C0C0C0">Test Case</th><th bgcolor="#C0C0C0">Time Taken (hh:mm:ss:ms)</th><th bgcolor="#C0C0C0">Result</th>';			
	print OUTPUT "@TC_SMOKE_Details";			
	print OUTPUT '</table>
	<dd>
	</dl>	
	</b></td></tr>';
	####################################
	# printing SNMP test case result
		print OUTPUT '<tr><td bgcolor="#BDBDBD" ><b>
	<dl >
	<dt>
	<b>* SNMP Node Based Test Cases >>></b>
	</dt>
	<dd >
	<br>
	<table border="1" bgcolor="#FFFFFF" cellpadding="3" cellspacing="3" align="center">
	<th bgcolor="#C0C0C0">Test Case ID</th><th bgcolor="#C0C0C0">Test Case</th><th bgcolor="#C0C0C0">Time Taken (hh:mm:ss:ms)</th><th bgcolor="#C0C0C0">Result</th>';			
	print OUTPUT "@TC_SNMP_Details";			
	print OUTPUT '</table>
	<dd>
	</dl>	
	</b></td></tr>';
	####################################
	# printing UTRAN test case result
		print OUTPUT '<tr><td bgcolor="#BDBDBD" ><b>
	<dl >
	<dt>
	<b>* UTRAN Node Based Test Cases >>></b>
	</dt>
	<dd >
	<br>
	<table border="1" bgcolor="#FFFFFF" cellpadding="3" cellspacing="3" align="center">
	<th bgcolor="#C0C0C0">Test Case ID</th><th bgcolor="#C0C0C0">Test Case</th><th bgcolor="#C0C0C0">Time Taken (hh:mm:ss:ms)</th><th bgcolor="#C0C0C0">Result</th>';			
	print OUTPUT "@TC_UTRAN_Details";			
	print OUTPUT '</table>
	<dd>
	</dl>	
	</b></td></tr>';
	####################################
	# printing LTE test case result
		print OUTPUT '<tr><td bgcolor="#BDBDBD" ><b>
	<dl >
	<dt>
	<b>* LTE Node Based Test Cases >>></b>
	</dt>
	<dd >
	<br>
	<table border="1" bgcolor="#FFFFFF" cellpadding="3" cellspacing="3" align="center">
	<th bgcolor="#C0C0C0">Test Case ID</th><th bgcolor="#C0C0C0">Test Case</th><th bgcolor="#C0C0C0">Time Taken (hh:mm:ss:ms)</th><th bgcolor="#C0C0C0">Result</th>';			
	print OUTPUT "@TC_LTE_Details";			
	print OUTPUT '</table>
	<dd>
	</dl>	
	</b></td></tr>';
	####################################
	# printing TSS test case result
		print OUTPUT '<tr><td bgcolor="#BDBDBD" ><b>
	<dl >
	<dt>
	<b>* TSS Node Based Test Cases >>></b>
	</dt>
	<dd >
	<br>
	<table border="1" bgcolor="#FFFFFF" cellpadding="3" cellspacing="3" align="center">
	<th bgcolor="#C0C0C0">Test Case ID</th><th bgcolor="#C0C0C0">Test Case</th><th bgcolor="#C0C0C0">Time Taken (hh:mm:ss:ms)</th><th bgcolor="#C0C0C0">Result</th>';			
	print OUTPUT "@TC_TSS_Details";			
	print OUTPUT '</table>
	<dd>
	</dl>	
	</b></td></tr>';
	####################################
	# printing CORE test case result
		print OUTPUT '<tr><td bgcolor="#BDBDBD" ><b>
	<dl >
	<dt>
	<b>* CORE Node Based Test Cases >>></b>
	</dt>
	<dd >
	<br>
	<table border="1" bgcolor="#FFFFFF" cellpadding="3" cellspacing="3" align="center">
	<th bgcolor="#C0C0C0">Test Case ID</th><th bgcolor="#C0C0C0">Test Case</th><th bgcolor="#C0C0C0">Time Taken (hh:mm:ss:ms)</th><th bgcolor="#C0C0C0">Result</th>';			
	print OUTPUT "@TC_CORE_Details";			
	print OUTPUT '</table>
	<dd>
	</dl>	
	</b></td></tr>';
	####################################
	# printing GRAN test case result
		print OUTPUT '<tr><td bgcolor="#BDBDBD" ><b>
	<dl >
	<dt>
	<b>* GRAN Node Based Test Cases >>></b>
	</dt>
	<dd >
	<br>
	<table border="1" bgcolor="#FFFFFF" cellpadding="3" cellspacing="3" align="center">
	<th bgcolor="#C0C0C0">Test Case ID</th><th bgcolor="#C0C0C0">Test Case</th><th bgcolor="#C0C0C0">Time Taken (hh:mm:ss:ms)</th><th bgcolor="#C0C0C0">Result</th>';			
	print OUTPUT "@TC_GRAN_Details";			
	print OUTPUT '</table>
	<dd>
	</dl>	
	</b></td></tr>';
	####################################
	print OUTPUT '</table>
	</body>
	</html>';

}




















1;