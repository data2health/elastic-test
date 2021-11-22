<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="es" uri="http://uiowa.edu/elasticsearch"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<c:set var="institute"><util:NIHGrantParser grantNumber="${param.grant_id}" component="institute" /></c:set>
<c:set var="serial_number"><util:NIHGrantParser grantNumber="${param.grant_id}" component="serial_number" /></c:set>

<es:index propertyName="es_test">
	<es:searchField fieldName="administering_ic" value="${institute}"/>
	<es:searchField fieldName="serial_number" value="${serial_number}"/>
	<es:searchField fieldName="support_year" value="1"/>
	<es:searchField fieldName="application_type" value="1"/>
	<es:search>
		<es:searchIterator>
			<a href="https://reporter.nih.gov/project-details/<es:hit label="application_id"/>">${param.grant_id}</a>
			<c:set var="grant_match" value="x"/>
		</es:searchIterator>
		<c:if test="${empty grant_match}">${param.grant_id}</c:if>
	</es:search>
</es:index>