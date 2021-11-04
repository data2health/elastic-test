<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="es" uri="http://uiowa.edu/elasticsearch"%>


<!DOCTYPE html>
<html lang="en-US">
<jsp:include page="head.jsp" flush="true">
	<jsp:param name="title" value="CTSAsearch" />
</jsp:include>
<style type="text/css" media="all">
@import "resources/layout.css";

ol {
	padding-inline-start: 10px;
	maring-left: 0;
	padding-left: 15px;
}

ul {
	padding-inline-start: 10px;
	maring-left: 0;
	padding-left: 25px;
}

input {
	padding-left: 7px;
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	box-sizing: border-box;
}

.desc-list {width =45%;display =inline-block;
	
}
</style>

<body class="home page-template-default page page-id-6 CD2H">
	<jsp:include page="header.jsp" flush="true" />

	<div class="container-fluid" style="padding-left: 5%; padding-right: 5%;">
		<br/> <br/> 
		<div id=form>
			<form method='POST' action='index.jsp'>
				<fieldset>
					<input class='search-box' name="query" value="${param.query}"
						size=50> <input type=submit name=submitButton value=Go!>
					<c:if test="${not empty param.query}">
						<a class="search-reset" href="index.jsp" title="Reset Search"><i
							class="far fa-times-circle"></i></a>
					</c:if>
				</fieldset>
			</form>
		</div>
		<br />
		<c:if test="${not empty param.query}">
			<es:index propertyName="es_test">

				<es:aggregator displayName="index" fieldName="_index" />
				<es:aggregator displayName="status"
					fieldName="overall_status.keyword" />
				<es:aggregator displayName="type" fieldName="study_type.keyword" />

				<es:search queryString="${param.query}" limitCriteria="1000">
					<div style="float: left">
						<h2>Aggregations</h2>
						<es:aggregationIterator>
							<es:aggregation>
								<p>
									<es:aggregationName />
								</p>
								<ul>
									<es:aggregationTermIterator>
										<li><es:aggregationTerm /> (<es:aggregationTermCount />)

										
									</es:aggregationTermIterator>
								</ul>
							</es:aggregation>
						</es:aggregationIterator>
					</div>
					<div style="float: left">
								<div id="results-header-box">
									<h3 id="results-header">Search Results:</h3>
									<p>Result Count: <es:count /></p>
								</div>
								<div id="results-table" onscroll="scrollFunction()">
									<table style="width:100%">
	  									<tr>
	    									<th>Result</th>
	    									<th>Source</th> 
	    									<th>Score</th> 
	  									</tr>
										<es:searchIterator>
											<tr>
												<td><a href="<es:hit label="url" />"><es:hit label="label" /></a></td>
												<td><es:hit label="_index" /></td>
												<td><es:hit label="score" /></td>
											<tr>
										</es:searchIterator>
									</table>
								</div>
								<div id="results-scroll" style="text-align:right;">
									<button id="backtop" title="Back to Top"><i class="fas fa-chevron-up"></i></button>
								</div>
					</div>
				</es:search>
			</es:index>
		</c:if>
		<div style="width: 100%; float: left">
			<jsp:include page="footer.jsp" flush="true" />
		</div>
	</div>
<script>
$('#backtop').on('click', function() {
	$('#results-table').scrollTop(0);
});


function scrollFunction() {
	  if ($('#results-table').scrollTop() < 1000) {
	    document.getElementById("backtop").style.opacity = 0;
	  } else {
	    document.getElementById("backtop").style.opacity = 0.8;
	  }
};


$('.collapse').on('show.bs.collapse', function(e) {
    $(e.target).siblings('.facet-list-dropdown').find('i').removeClass().addClass('fas fa-chevron-down');
});

$('.collapse').on('hide.bs.collapse', function(e) {
    $(e.target).siblings('.facet-list-dropdown').find('i').removeClass().addClass('fas fa-chevron-right');
});

$('.collapse').on('shown.bs.collapse', function(e) {
    $(e.target).siblings('.facet-list-dropdown').find('i').removeClass().addClass('fas fa-chevron-down');
    if ($("#facet-box").height() > $(window).width()*.3){
    	$("#results-table").css({'height':($("#facet-box").height()-$("#results-header-box").height()+'px')});
    } else {
    	$("#results-table").css({'height':($(window).width()*.3+'px')});
    };
    
});

$('.collapse').on('hidden.bs.collapse', function(e) {
    $(e.target).siblings('.facet-list-dropdown').find('i').removeClass().addClass('fas fa-chevron-right');
    if ($("#facet-box").height() > $(window).width()*.3){
    	$("#results-table").css({'height':($("#facet-box").height()-$("#results-header-box").height()+'px')});
    } else {
    	$("#results-table").css({'height':($(window).width()*.3+'px')});
    };
});


if ($("#facet-box").height() > $(window).width()*.3){
	$("#results-table").css({'height':($("#facet-box").height()-$("#results-header-box").height()+'px')});
} else {
	$("#results-table").css({'height':($(window).width()*.3+'px')});
};

</script>
</body>

</html>
