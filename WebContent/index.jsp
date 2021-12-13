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
<style>
.cards tbody tr {
	float: left;
	width: 20rem;
	margin: 0.5rem;
	border: 0.0625rem solid rgba(0, 0, 0, .125);
	border-radius: .25rem;
	box-shadow: 0.25rem 0.25rem 0.5rem rgba(0, 0, 0, 0.25);
}

.cards tbody td {
	display: block;
}

.cards thead {
	display: none;
}

.cards td:before {
	content: attr(data-label);
	display: inline;
	position: relative;
	font-size: 85%;
	top: -0.5rem;
	float: left;
	color: #808080;
	min-width: 4rem;
	margin-left: 0;
	margin-right: 1rem;
	text-align: left;
}

tr.selected td:before {
	color: #404040;
}

.table .fa {
	font-size: 2.5rem;
	text-align: left;
}

.cards .fa {
	font-size: 7.5rem;
}
</style>

<body class="home page-template-default page page-id-6 CD2H">
	<jsp:include page="header.jsp" flush="true" />

	<div class="container-fluid" style="padding-left: 5%; padding-right: 5%;">
		<br /> <br />
		<form method='GET' action='index.jsp'>
			<div id=form>
				<c:if test="${false}">
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
				</c:if>
				<h2>
					<i style="color: #7bbac6;" class="fas fa-search"></i> Faceted Search
				</h2>
				<fieldset>
					<input class='search-box' name="query" value="${param.query}" size=50> <input type=submit name=submitButton value=Go!>
					<c:if test="${not empty param.query}">
						<a class="search-reset" href="index.jsp" title="Reset Search"><i class="far fa-times-circle"></i></a>
					</c:if>
				</fieldset>
			</div>
			<br />
			<c:if test="${not empty param.query}">
				<es:index propertyName="es_test">
					<c:forEach var="pname" items="${pageContext.request.parameterNames}">
						<c:forEach items="${paramValues[pname]}" var="selectedValue">
							<c:choose>
								<c:when test="${pname == 'query' || pname == 'submitButton' || pname == 'result_table_length' }">
								</c:when>
								<c:when test="${pname == 'index'}">
									<es:filter termString="${selectedValue}" fieldName="_${pname }" />
								</c:when>
								<c:when test="${pname == 'type'}">
									<es:filter termString="${selectedValue}" fieldName="study_type.keyword" />
								</c:when>
								<c:when test="${pname == 'status'}">
									<es:filter termString="${selectedValue}" fieldName="overall_status.keyword" />
								</c:when>
								<c:when test="${pname == 'datatype'}">
									<es:filter termString="${selectedValue}" fieldName="raw._source.dataItem.dataTypes.keyword" />
								</c:when>
								<c:when test="${pname == 'tool-type'}">
									<es:filter termString="${selectedValue}" fieldName="tool.toolType.keyword" />
								</c:when>
								<c:otherwise>
									<es:filter termString="${selectedValue}" fieldName="${pname}.keyword" />
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:forEach>

					<es:aggregator displayName="index" fieldName="_index" />
					<es:aggregator displayName="entity" fieldName="entity.keyword" />
					<es:aggregator displayName="tool" fieldName="tool.toolType.keyword" />
					<es:aggregator displayName="overall_status" fieldName="overall_status.keyword" />
					<es:aggregator displayName="study_type" fieldName="study_type.keyword" />
					<es:aggregator displayName="datatype" fieldName="raw._source.dataItem.dataTypes.keyword" size="12" />

					<es:searchField boost="4" fieldName="label" />
					<es:searchField boost="4" fieldName="raw.name" />
					<es:searchField boost="4" fieldName="name" />

					<es:resultIncludeField fieldName="url" />
					<es:resultIncludeField fieldName="label" />
					<es:resultIncludeField fieldName="description" />
					<es:resultIncludeField fieldName="video_thumbnail.url" />
					<es:resultIncludeField fieldName="raw.language" />
					<es:resultIncludeField fieldName="raw.topics" />
					<es:resultIncludeField fieldName="raw.name" />
					<es:resultIncludeField fieldName="raw.bio" />
					<es:resultIncludeField fieldName="raw.avatar_url" />
					<es:resultIncludeField fieldName="raw._source.datasetDistributions.storedIn" />
					<es:resultIncludeField fieldName="raw._source.dataItem.dataTypes" />
					<es:resultIncludeField fieldName="raw.attributes.container-title" />
					<es:resultIncludeField fieldName="core_project_num" />
					<es:resultIncludeField fieldName="budget_start" />
					<es:resultIncludeField fieldName="budget_end" />
					<es:resultIncludeField fieldName="medline_journal_info.medline_ta" />
					<es:resultIncludeField fieldName="author" />
					<es:resultIncludeField fieldName="article_id" />
					<es:resultIncludeField fieldName="title" />
					<es:resultIncludeField fieldName="site.description" />
					<es:resultIncludeField fieldName="tool" />

					<es:resultIncludeField fieldName="doi" />
					<es:resultIncludeField fieldName="name" />

					<c:set var="drillDownList">
						<c:forEach var="pname" items="${pageContext.request.parameterNames}">
							${pname}
						</c:forEach>

					</c:set>
					<es:search queryString="${param.query}" limitCriteria="1000">
						<div style="float: left">
							<div id="facet-box" style="width: 100%; padding: 0px 80px 0px 0px; float: left">
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
															<button class="btn btn-facet" type="button" data-toggle="collapse" data-target='${"#facet-med-content-box"}${fn:replace(facet1," ", "")}' aria-expanded="false"
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
																	<li><input type="checkbox" id="index" name="<es:aggregationName />" value="<es:aggregationTerm />" class="form-check-input"
																		<es:aggregationTermStatus request="${pageContext.request}"/>>
																		<c:set var="term"><es:aggregationTerm /></c:set>
																		<c:choose>
																			<c:when test="${term == 'person' || term == 'cd2h-profile-vivo' || term == 'cd2h-github-user'}">
																				<i class="fas fa-user"></i>
																			</c:when>
																			<c:when test="${term == 'organization' || term == 'cd2h-github-organization'}">
																				<i class="fas fa-users"></i>
																			</c:when>
																			<c:when test="${term == 'repository' || term == 'cd2h-github-repository'}">
																				<i class="fas fa-archive"></i>
																			</c:when>
																			<c:when test="${term == 'dataset' || term == 'cd2h-datamed' || term == 'cd2h-datacite'}">
																				<i class="fas fa-database"></i>
																			</c:when>
																			<c:when test="${term == 'grant' || term == 'cd2h-nih-reporter'}">
																				<i class="fas fa-search-dollar"></i>
																			</c:when>
																			<c:when test="${term == 'publication' || term == 'cd2h-nih-litcovid'}">
																				<i class="fas fa-book-open"></i>
																			</c:when>
																			<c:when test="${term == 'clinical trial' || term == 'cd2h-clinical-trials'}">
																				<i class="fas fa-microscope"></i>
																			</c:when>
																			<c:when test="${term == 'video clip' || term == 'cd2h-youtube-video' || term == 'cd2h-youtube-playlist' || term == 'cd2h-youtube-channel'}">
																				<i class="fas fa-file-video"></i>
																			</c:when>
																			<c:otherwise>
																				<i class="fas fa-question"></i>
																			</c:otherwise>
																		</c:choose>
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
								<h3 id="results-header">
									Search Results:
								</h3>
								<p>
									Result Count:
									<es:count />
								</p>
								<ul>
									<li>The card / table icon at the top-left of the table toggles between card view and table view.
									<li>The detail icon displays additional information regarding the hit (currently only interesting for LitCOVID articles).
									<li>The document icon displays the entire original JSON source document.
									<li>The raw result icon displays as JSON the elements of the original source document programmatically selected for retrieval and used by the result and details columns.
								</ul>
							</div>
							<div>
								<table id="result_table" class="display" style="width: 100%">
									<thead>
										<tr>
											<th>Entity</th>
											<th>Result</th>
											<th>Source</th>
											<th>Rank</th>
											<th>Score</th>
											<th>Details</th>
											<th>Document</th>
											<th>Raw Result</th>
										</tr>
									</thead>
									<tbody>
										<es:searchIterator>
											<c:set var="index">
												<es:hit label="_index" />
											</c:set>
											<tr>
												<c:choose>
													<c:when test="${index == 'cd2h-github-user' || index == 'cd2h-profile-vivo'}">
														<td><i class="fas fa-user"></i></td>
													</c:when>
													<c:when test="${index == 'cd2h-github-organization'}">
														<td><i class="fas fa-users"></i></td>
													</c:when>
													<c:when test="${index == 'cd2h-github-repository'}">
														<td><i class="fas fa-archive"></i></td>
													</c:when>
													<c:when test="${index == 'cd2h-datamed' || index == 'cd2h-datacite'}">
														<td><i class="fas fa-database"></i></td>
													</c:when>
													<c:when test="${index == 'cd2h-nih-reporter'}">
														<td><i class="fas fa-search-dollar"></i></td>
													</c:when>
													<c:when test="${index == 'cd2h-nih-litcovid'}">
														<td><i class="fas fa-book-open"></i></td>
													</c:when>
													<c:when test="${index == 'cd2h-linical-trials'}">
														<td><i class="fas fa-microscope"></i></td>
													</c:when>
													<c:when test="${term == 'video clip' || term == 'cd2h-youtube-video' || term == 'cd2h-youtube-playlist' || term == 'cd2h-youtube-channel'}">
														<td><i class="fas fa-file-video"></i></td>
													</c:when>
													<c:otherwise>
														<td><i class="fas fa-question"></i></td>
													</c:otherwise>
												</c:choose>
												<c:choose>
													<c:when test="${fn:startsWith(index,'cd2h-')}">
														<td data-order="<es:hit label="label" />"><h5>
																<a href="<es:hit label="url" />"><es:hit label="label" /></a>
															</h5> <c:choose>
																<c:when test="${index == 'cd2h-youtube-video'}">
																	<table>
																		<tr>
																			<td><es:hit label="description" /></td>
																			<td style="vertical-align: top"><img src='<es:hit label="video_thumbnail.url" />'></td>
																		</tr>
																	</table>
																</c:when>
																<c:when test="${index == 'cd2h-youtube-playlist'}">
																	<es:hit label="description" />
																</c:when>
																<c:when test="${index == 'cd2h-youtube-channel'}">
																	<es:hit label="description" />
																</c:when>
																<c:when test="${index == 'cd2h-github-repository'}">
																	<es:hit label="raw.language" />
																	<es:hit label="raw.topics" />
																</c:when>
																<c:when test="${index == 'cd2h-github-user'}">
																	<table>
																		<tr>
																			<td><es:hit label="raw.name" />, <es:hit label="raw.bio" /></td>
																			<td style="vertical-align: top"><img src='<es:hit label="raw.avatar_url" />' width="100px"></td>
																		</tr>
																	</table>
																</c:when>
																<c:when test="${index == 'cd2h-github-organization'}">
																	<table>
																		<tr>
																			<td><es:hit label="raw.name" /></td>
																			<td style="vertical-align: top"><img src='<es:hit label="raw.avatar_url" />' width="100px"></td>
																		</tr>
																	</table>
																</c:when>
																<c:when test="${index == 'cd2h-datamed'}">
																	<es:hit label="raw._source.datasetDistributions.storedIn" />
																	<br>
																	<strong>Data Types:</strong>
																	<es:arrayIterator label="raw._source.dataItem.dataTypes" var="type">
																		<es:hit label="" />
																		<c:if test="${!type.isLast}">,</c:if>
																	</es:arrayIterator>
																</c:when>
																<c:when test="${index == 'cd2h-datacite'}">
																	<es:hit label="raw.attributes.container-title" />
																</c:when>
																<c:when test="${index == 'cd2h-nih-reporter'}">
																	<es:hit label="core_project_num" /> : <es:hit label="budget_start" /> to <es:hit label="budget_end" />
																</c:when>
																<c:when test="${index == 'cd2h-nih-litcovid'}">
																	<es:hit label="medline_journal_info.medline_ta" />
																	<br>
																	<strong>Authors:</strong>
																	<es:arrayIterator label="author" var="auth" limitCriteria="3">
																		<c:set var="coll">
																			<es:hit label="collective_name" />
																		</c:set>
																		<c:choose>
																			<c:when test="${empty coll}">
																				<es:hit label="initials" />
																				<es:hit label="last_name" />
																				<c:if test="${!auth.isLast}">,</c:if>
																			</c:when>
																			<c:otherwise>
																				<es:hit label="collective_name" />
																				<c:if test="${!auth.isLast}">,</c:if>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${auth.hitRank == 3 && auth.count > 3}">, et al.</c:if>
																	</es:arrayIterator>
																	<c:remove var="doi" />
																	<es:arrayIterator label="article_id" var="ident">
																		<c:if test='${ident.current.get("id_type") == "doi" }'>
																			<c:set var="doi">
																				<es:hit label="article_id" />
																			</c:set>
																			<c:if test="${fn:startsWith(doi,'10')}">
																				<c:set var="doi" value="http://dx.doi.org/${doi}" />
																			</c:if>
																			<br>
																			<strong>DOI: </strong>
																			<a href="${doi}"><es:hit label="article_id" /></a>
																		</c:if>
																	</es:arrayIterator>
																</c:when>
																<c:when test="${index == 'cd2h-profile-vivo'}">
																	<es:hit label="title" />, <es:hit label="site.description" />
																</c:when>
															</c:choose></td>
													</c:when>
													<c:when test="${fn:startsWith(index,'outbreak')}">
														<td data-order="<es:hit label="name" />"><h5>
																<c:set var="doi">
																	<es:hit label="doi" />
																</c:set>
																<c:choose>
																	<c:when test="${not empty doi}">
																		<a href="http://dx.doi.org/<es:hit label="doi" />"><es:hit label="name" /></a>
																	</c:when>
																	<c:otherwise>
																		<a href="<es:hit label="url" />"><es:hit label="name" /></a>
																	</c:otherwise>
																</c:choose>
															</h5></td>
													</c:when>
													<c:when test="${fn:startsWith(index,'csbc')}">
														<td data-order="<es:hit label="tool.toolName" />"><h5>
																<a href="<es:hit label="tool.homepage" />"><es:hit label="tool.toolName" /></a>
															</h5><es:hit label="tool.description" /></td>
													</c:when>
													<c:otherwise>failed index match</c:otherwise>
												</c:choose>
												</td>
												<td><es:hit label="_index" /></td>
												<td><es:hitRank /></td>
												<td><es:hit label="score" /></td>
												<td><a onclick="detail_render('details_<es:hit label="_id"/>', '<es:hit label="url" />');"><i style="color: #7bbac6;" class="fas fa-search"></i></a>
													<div id="details_<es:hit label="_id"/>"></div></td>
												<td><a href="source.jsp?url=<es:hit label="url"/>"><i style="color: #7bbac6;" class="fas fa-search"></i></a></td>
												<td><a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion_<es:hit label="_id"/>" href="#details_<es:hit label="_id"/>"><i style="color: #7bbac6;"
														class="fas fa-search"></i></a>
													<div id="accordion_<es:hit label="_id"/>">
														<div id="details_<es:hit label="_id"/>" class="panel-collapse collapse">
															<pre>
																<code>
																	<es:document escape="true" />
																</code>
															</pre>
														</div>
													</div></td>
											</tr>
										</es:searchIterator>
									</tbody>
								</table>
								<script>
									$(document).ready(function() {
										$('#result_table').DataTable( {
							                "dom": 'Blfrtip',
							                buttons: [
							                    {
							                        text: '<i class="fa fa-id-badge fa-fw fa-lg" aria-hidden="true"></i>',
							                        action: function (e, dt, button, config) {
							                            $("#result_table").toggleClass("cards");
							                            $("#card-toggle .fa").toggleClass([ "fa-table", "fa-id-badge" ]);

							                            if($("#result_table").hasClass("cards")){

							                                // Create an array of labels containing all table headers
							                                var labels = [];
							                                $('#result_table').find('thead th').each(function() {
							                                    labels.push($(this).text());
							                                });

							                                // Add data-label attribute to each cell
							                                $('#result_table').find('tbody tr').each(function() {
							                                    $(this).find('td').each(function(column) {
							                                        $(this).attr('data-label', labels[column]);
							                                    });
							                                });

							                                var max = 0;
							                                $('#result_table tr').each(function() {
							                                    max = Math.max($(this).height(), max);
							                                }).height("auto");

							                            } else {

							                                // Remove data-label attribute from each cell
							                                $('#result_table').find('td').each(function() {
							                                    $(this).removeAttr('data-label');
							                                });

							                                $("#result_table tr").each(function(){
							                                    $(this).height("auto");
							                                });
							                                
							                            }
							                        },
							                        attr:  {
							                            title: 'Change views',
							                            id: 'card-toggle'
							                        }
							                    }
							                ],

											pageLength: 3,
									    	lengthMenu: [ 3, 5, 10, 25, 50, 75, 100 ],
									    	order: [[2, 'asc']]
										} );
									});
								</script>
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
		
		function detail_render(div_id, url) {
			var theDIV = document.getElementById(div_id);
			if (theDIV.innerHTML == "") {
				$("#"+div_id).load("details.jsp?url="+url);
			} else {
			//	alert('occupied');
				theDIV.innerHTML = "";
			}
		}

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
