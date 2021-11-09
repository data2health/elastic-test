<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="es" uri="http://uiowa.edu/elasticsearch"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


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

	<div class="container-fluid"
		style="padding-left: 5%; padding-right: 5%;">
		<br /> <br />
		<form method='GET' action='index.jsp'>
			<div id=form>
				<p>Submitted parameters:</p>
				<table>
					<c:forEach var="pname" items="${pageContext.request.parameterNames}">
						<c:forEach items="${paramValues[pname]}" var="selectedValue">
							<tr>
								<td><c:out value="${pname}" /></td>
								<td>${selectedValue}</td>
							</tr>
						</c:forEach>
					</c:forEach>
				</table>
			<h2>
				<i style="color: #7bbac6;" class="fas fa-search"></i> Faceted Search
			</h2>
[]				<fieldset>
					<input class='search-box' name="query" value="${param.query}"
						size=50> <input type=submit name=submitButton value=Go!>
					<c:if test="${not empty param.query}">
						<a class="search-reset" href="index.jsp" title="Reset Search"><i
							class="far fa-times-circle"></i></a>
					</c:if>
				</fieldset>
			</div>
			<br />
			<c:if test="${not empty param.query}">
				<es:index propertyName="es_test">
					<c:forEach var="pname"
						items="${pageContext.request.parameterNames}">
						<c:forEach items="${paramValues[pname]}" var="selectedValue">
							<c:choose>
								<c:when test="${pname == 'query' || pname == 'submitButton' }">
								</c:when>
								<c:when test="${pname == 'index'}">
									<es:filter termString="${selectedValue}" fieldName="_${pname }" />
								</c:when>
								<c:when test="${pname == 'type'}">
									<es:filter termString="${selectedValue}"
										fieldName="study_type.keyword" />
								</c:when>
								<c:when test="${pname == 'status'}">
									<es:filter termString="${selectedValue}"
										fieldName="overall_status.keyword" />
								</c:when>
								<c:when test="${pname == 'datatype'}">
									<es:filter termString="${selectedValue}"
										fieldName="raw._source.dataItem.dataTypes.keyword" />
								</c:when>
								<c:otherwise>
									<es:filter termString="${selectedValue}"
										fieldName="${pname}.keyword" />
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:forEach>

					<es:aggregator displayName="index" fieldName="_index" />
					<es:aggregator displayName="entity" fieldName="entity.keyword" />
					<es:aggregator displayName="status"
						fieldName="overall_status.keyword" />
					<es:aggregator displayName="type" fieldName="study_type.keyword" />
					<es:aggregator displayName="datatype"
						fieldName="raw._source.dataItem.dataTypes.keyword" size="12" />

					<c:set var="drillDownList">
						<c:forEach var="pname" items="${pageContext.request.parameterNames}">
							${pname}
						</c:forEach>
					
					</c:set>
					<es:search queryString="${param.query}" limitCriteria="1000">
						<div style="float: left">
							<div id="facet-box"
								style="width: 100%; padding: 0px 80px 0px 0px; float: left">
								<h5>Aggregations</h5>
								<div class='card' style="with: 100%">
									<div class="card-body" style="padding-right: 30px">
										<es:aggregationIterator>
											<es:aggregation>
												<c:set var="facet1">
													<es:aggregationName />
												</c:set>
												<c:set var="aggregationCount">
													<es:aggregationCount />
												</c:set>
												<c:if test="${aggregationCount > 0 }">
													<div class='facet-top-content-box'>
														<c:set var="chevrontop">
															<c:choose>
																<c:when test="${fn:contains(drillDownList, facet1)}">
																	fas fa-chevron-down 
																</c:when>
																<c:otherwise>
																	fas fa-chevron-right
																</c:otherwise>
															</c:choose>
														</c:set>
														<div class='facet-list-dropdown'>
															<button class="btn btn-facet" type="button"
																data-toggle="collapse"
																data-target='${"#facet-med-content-box"}${fn:replace(facet1," ", "")}'
																aria-expanded="false"
																aria-controls='${"facet-med-content-box"}${fn:replace(facet1," ", "")}'>
																<span class="fas-li"><i class="${chevrontop}"></i></span>
															</button>
														</div>
														<div class='facet-list-item'>
															<es:aggregationName />
														</div>
														<!-- Toggles Collapse based on which facets are hot  -->
														<c:set var="position_med">
															<c:choose>
																<c:when test="${fn:contains(drillDownList, facet1)}">
																	collapse show
																</c:when>
																<c:otherwise>
																	collapse
																</c:otherwise>
															</c:choose>
														</c:set>

														<div class="${position_med}" id='${"facet-med-content-box"}${fn:replace(facet1," ", "")}'>
															<ol class="facetList">
																<es:aggregationTermIterator>
																	<li><input type="checkbox" id="index"
																		name="<es:aggregationName />"
																		value="<es:aggregationTerm />"
																		class="form-check-input"
																		<es:aggregationTermStatus request="${pageContext.request}"/>>
																		<es:aggregationTerm /> (<es:aggregationTermCount />)
																	
																</es:aggregationTermIterator>
															</ol>
														</div>
													</div>
												</c:if>
											</es:aggregation>
										</es:aggregationIterator>
									</div>
								</div>
							</div>
						</div>
						<div style="float: left">
							<div id="results-header-box">
								<h3 id="results-header">Search Results:</h3>
								<p>
									Result Count:
									<es:count />
								</p>
							</div>
							<div id="results-table" onscroll="scrollFunction()">
								<table style="width: 100%">
									<tr>
										<th>Result</th>
										<th>Source</th>
										<th>Score</th>
									</tr>
									<es:searchIterator>
										<tr>
											<td><h5>
													<a href="<es:hit label="url" />"><es:hit label="label" /></a>
												</h5> <c:set var="index">
													<es:hit label="_index" />
												</c:set> <c:choose>
													<c:when test="${index == 'cd2h-youtube-video'}">
														<es:hit label="description" />
													</c:when>
													<c:when test="${index == 'cd2h-youtube-playlist'}">
														<es:hit label="description" />
													</c:when>
													<c:when test="${index == 'cd2h-youtube-channel'}">
														<es:hit label="description" />
													</c:when>
													<c:when test="${index == 'cd2h-github-repository'}">
														<es:hit label="raw/language" />
													</c:when>
													<c:when test="${index == 'cd2h-github-user'}">
														<es:hit label="raw/name" />, <es:hit label="raw/bio" />
													</c:when>
													<c:when test="${index == 'cd2h-datamed'}">
														<es:hit label="raw/_source/datasetDistributions/storedIn" />
													</c:when>
													<c:when test="${index == 'cd2h-datacite'}">
														<es:hit label="raw/attributes/container-title" />
													</c:when>
													<c:when test="${index == 'cd2h-nih-reporter'}">
														<es:hit label="core_project_num" /> : <es:hit
															label="budget_start" /> to <es:hit label="budget_end" />
													</c:when>
													<c:when test="${index == 'cd2h-profile-vivo'}">
														<es:hit label="title" />, <es:hit
															label="site/description" />
													</c:when>
												</c:choose></td>
											<td><es:hit label="_index" /></td>
											<td><es:hit label="score" /></td>
										<tr>
									</es:searchIterator>
								</table>
							</div>
							<div id="results-scroll" style="text-align: right;">
								<button id="backtop" title="Back to Top">
									<i class="fas fa-chevron-up"></i>
								</button>
							</div>
						</div>
					</es:search>
				</es:index>
			</c:if>
			<div style="width: 100%; float: left">
				<jsp:include page="footer.jsp" flush="true" />
			</div>
		</form>
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

		$('.collapse').on(
				'show.bs.collapse',
				function(e) {
					$(e.target).siblings('.facet-list-dropdown').find('i')
							.removeClass().addClass('fas fa-chevron-down');
				});

		$('.collapse').on(
				'hide.bs.collapse',
				function(e) {
					$(e.target).siblings('.facet-list-dropdown').find('i')
							.removeClass().addClass('fas fa-chevron-right');
				});

		$('.collapse').on(
				'shown.bs.collapse',
				function(e) {
					$(e.target).siblings('.facet-list-dropdown').find('i')
							.removeClass().addClass('fas fa-chevron-down');
					if ($("#facet-box").height() > $(window).width() * .3) {
						$("#results-table")
								.css(
										{
											'height' : ($("#facet-box")
													.height()
													- $("#results-header-box")
															.height() + 'px')
										});
					} else {
						$("#results-table").css({
							'height' : ($(window).width() * .3 + 'px')
						});
					}
					;

				});

		$('.collapse').on(
				'hidden.bs.collapse',
				function(e) {
					$(e.target).siblings('.facet-list-dropdown').find('i')
							.removeClass().addClass('fas fa-chevron-right');
					if ($("#facet-box").height() > $(window).width() * .3) {
						$("#results-table")
								.css(
										{
											'height' : ($("#facet-box")
													.height()
													- $("#results-header-box")
															.height() + 'px')
										});
					} else {
						$("#results-table").css({
							'height' : ($(window).width() * .3 + 'px')
						});
					}
					;
				});

		if ($("#facet-box").height() > $(window).width() * .3) {
			$("#results-table").css(
					{
						'height' : ($("#facet-box").height()
								- $("#results-header-box").height() + 'px')
					});
		} else {
			$("#results-table").css({
				'height' : ($(window).width() * .3 + 'px')
			});
		};
	</script>
</body>

</html>
