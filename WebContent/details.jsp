<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="es" uri="http://uiowa.edu/elasticsearch"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<div style="width:500px">
	<es:index propertyName="es_test">
		<es:searchField boost="4" fieldName="url" />
		<es:search queryString="${param.url}" limitCriteria="1" fieldWildCard="false">
			<es:searchIterator>
				<c:set var="index">
					<es:hit label="_index" />
				</c:set>
				<c:choose>
					<c:when test="${index == 'cd2h-youtube-video'}">
						<table>
							<tr>
								<td><es:hit label="description" /></td>
								<td style="vertical-align: top"><img
									src='<es:hit label="video_thumbnail.url" />'></td>
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
								<td style="vertical-align: top"><img
									src='<es:hit label="raw.avatar_url" />' width="100px"></td>
							</tr>
						</table>
					</c:when>
					<c:when test="${index == 'cd2h-github-organization'}">
						<table>
							<tr>
								<td><es:hit label="raw.name" /></td>
								<td style="vertical-align: top"><img
									src='<es:hit label="raw.avatar_url" />' width="100px"></td>
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
						<es:hit label="core_project_num" /> : <es:hit label="budget_start" /> to <es:hit
							label="budget_end" />
					</c:when>
					<c:when test="${index == 'cd2h-nih-litcovid'}">
						<es:hit label="medline_journal_info.medline_ta" />
						<br>
						<strong>Authors:</strong>
						<es:arrayIterator label="author" var="auth">
							<c:choose>
								<c:when test='${auth.current.get("collective_name") == "null"}'>
									<c:remove var="orcid"/>
									<es:arrayIterator label="author_identifier" var="ident">
										<c:if test='${ident.current.get("source") == "ORCID" }'>
											<c:set var="orcid"><es:hit label="identifier" /></c:set>
											<c:if test="${fn:startsWith(orcid,'0000')}">
												<c:set var="orcid" value="http://orcid.org/${orcid}"/>
											</c:if>
										</c:if>
									</es:arrayIterator>
									<c:if test="${not empty orcid}"><a href="${orcid}"></c:if>
									<es:hit label="initials" />
									<es:hit label="last_name" />
									<c:if test="${not empty orcid}"></a></c:if>
										(<i><es:arrayIterator label="author_affiliation" var="aff">
											<es:hit label="affiliation" />
											<c:if test="${!aff.isLast}">,</c:if>
										</es:arrayIterator></i>)<c:if test="${!auth.isLast}">,</c:if>
								</c:when>
								<c:otherwise>
									<es:hit label="collective_name" />
									<c:if test="${!auth.isLast}">,</c:if>
								</c:otherwise>
							</c:choose>
						</es:arrayIterator>
						
						<es:arrayIterator label="abstract" var="abstr">
							<c:if test="${abstr.isFirst}"><br><h5>Abstract:</h5></c:if>
							<strong><es:hit label="label" /></strong>
							<p><es:hit label="abstract" /></p>
						</es:arrayIterator>
						
						<es:arrayIterator label="keyword" var="key">
							<c:if test="${key.isFirst}"><br><strong>Keywords:</strong><ul></c:if>
							<es:hit label="keyword" />
							<c:if test="${!key.isLast}">,</c:if>
							<c:if test="${key.isLast}"></ul></c:if>
						</es:arrayIterator>

						<es:arrayIterator label="grant_info" var="grant">
							<c:if test="${grant.isFirst}"><br><strong>Grant Support:</strong><ul></c:if>
							<li><es:hit label="agency" />:
							<c:set var="grant_id"><es:hit label="grant_id" /></c:set>
							<jsp:include page="renderReporterLink.jsp">
								<jsp:param value="${grant_id}" name="grant_id"/>
							</jsp:include>
							<c:if test="${grant.isLast}"></ul></c:if>
						</es:arrayIterator>
					</c:when>
					<c:when test="${index == 'cd2h-profile-vivo'}">
						<es:hit label="title" />, <es:hit label="site.description" />
					</c:when>
				</c:choose>
			</es:searchIterator>
		</es:search>
	</es:index>
</div>
