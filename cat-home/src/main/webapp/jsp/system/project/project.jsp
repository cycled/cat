<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="a" uri="/WEB-INF/app.tld"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="res" uri="http://www.unidal.org/webres"%>
<%@ taglib prefix="w" uri="http://www.unidal.org/web/core"%>

<jsp:useBean id="ctx" type="com.dianping.cat.system.page.config.Context" scope="request"/>
<jsp:useBean id="payload" type="com.dianping.cat.system.page.config.Payload" scope="request"/>
<jsp:useBean id="model" type="com.dianping.cat.system.page.config.Model" scope="request"/>

<a:config>
	<res:useJs value="${res.js.local['alarm_js']}" target="head-js" />
	
	<script type="text/javascript">
		$(document).ready(function() {
			$('#projects_config').addClass('active open');
			$('#projects').addClass('active');
			
			$.widget( "custom.catcomplete", $.ui.autocomplete, {
				_renderMenu: function( ul, items ) {
					var that = this,
					currentCategory = "";
					$.each( items, function( index, item ) {
						if ( item.category != currentCategory ) {
							ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
							currentCategory = item.category;
						}
						that._renderItemData( ul, item );
					});
				}
			});
			
			var data = [];
			<c:forEach var="project" items="${model.projects}">
						var item = {};
						item['label'] = '${project.domain}';
						item['category'] ='${project.department} - ${project.projectLine}';
						
						data.push(item);
			</c:forEach>
					
			$( "#search" ).catcomplete({
				delay: 0,
				source: data
			});
			
			$("#search_go").bind("click",function(e){
				var newUrl = '/cat/s/config?op=projects&domain='+$( "#search" ).val() +'&date=${model.date}';
				window.location.href = newUrl;
			});
			$('#wrap_search').submit(
				function(){
					var newUrl = '/cat/s/config?op=projects&domain='+$( "#search" ).val() +'&date=${model.date}';
					window.location.href = newUrl;
					return false;
				}		
			);
		});
	</script>
	<div class="navbar-header pull-left position" style="width:350px;MARGIN-LEFT:10%;MARGIN-TOP:5px;padding:5px;">
		<form id="wrap_search" style="margin-bottom:0px;">
		<div class="input-group">
			<c:if test="${not empty payload.project.domain}">
				<c:set var="domain" value="${payload.project.domain}"/>
			</c:if>
			<c:if test="${not empty payload.domain}">
				<c:set var="domain" value="${payload.domain}"/>
			</c:if>
			<c:if test="${empty domain}">
				<c:set var="domain" value="cat"/>
			</c:if>
			<span class="input-icon" style="width:300px;">
				<input type="text" placeholder="input domain for search" value="${domain}" class="search-input search-input form-control ui-autocomplete-input" id="search" autocomplete="off" />
				<i class="ace-icon fa fa-search nav-search-icon"></i>
				</span>
				<span class="input-group-btn" style="width:50px">
				<button class="btn btn-sm btn-primary" type="button" id="search_go">
				Go
				</button>
				</span>
			</div>
		</form>
	</div>
	<br/>
	<br/>
	<br/>
	<div style="padding:5px;">
	<form name="projectUpdate" id="form" method="get" action="${model.pageUri}?op=updateSubmit">
	<table class="table table-striped table-condensed ">
		<input type="hidden" name="project.id" value="${model.project.id}" />
		<input type="hidden" name="project.domain" value="${model.project.domain}" />
		<input type="hidden" name="project.bu" value="${model.project.bu}" />
		<input type="hidden" name="project.cmdbProductline" value="${model.project.cmdbProductline}" />
		<input type="hidden" name="project.level" value="${model.project.level}" />
		<input type="hidden" name="op" value="updateSubmit" />
		<tr>
			<td style="width:10%;">项目名称</td>
			<td>${model.project.domain}</td>
			<td style="color:red">注意：如果CMDB中存在该项目信息，信息修改会被CMDB同步更新覆盖掉。</td>
		</tr>
		<tr>
			<td style="width:10%;">CMDB项目名称</td>
			<td><input type="name" name="project.cmdbDomain" value="${model.project.cmdbDomain}" required/></td>
			<td>cmdb中项目统一名称</td>
		</tr>
		<tr>
			<td style="width:10%;">所属部门</td>
			<td><input type="name" name="project.department" value="${model.project.department}" required/></td>
			<td style='color:red'>（一级分类）建议填写，主站、手机、团购、搜索、架构</td>
		</tr>
		<tr>
			<td style="width:10%;">产品线</td>
			<td><input type="name" name="project.projectLine" value="${model.project.projectLine}" required/></td>
			<td style='color:red'>（二级分类）由各自业务线决定,建议字数小于4</td>
		</tr>
		<tr>
			<td style="width:10%;">负责人</td>
			<td><input type="name" name="project.owner" value="${model.project.owner}"/></td>
			<td>可选字段</td>
		</tr>
		<tr>
			<td style="width:10%;">项目组邮件</td>
			<td><input type="name" name="project.email" size="50" value="${model.project.email}"/></td>
			<td>可选字段(多个，逗号分割)</td>
		</tr>
		<tr>
			<td>项目组号码</td>
			<td><input type="name" name="project.phone" size="50" value="${model.project.phone}"/></td>
			<td>可选字段(多个，逗号分割)</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><input class='btn btn-primary btn-sm' type="submit" name="submit" value="提交" /></td>
		</tr>
	</table>
</form>
</div>
</a:config>
<style>
.input-icon>.ace-icon {
	z-index: 0;
}
</style>
