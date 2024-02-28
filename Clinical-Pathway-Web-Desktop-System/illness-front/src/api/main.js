import ajax from "./index";

// 登录
export const reqLogin = user => ajax('/Login/login', user, 'POST');
// 查询路径配置列表
export const reqPathList = data => ajax('/Path/indexPath', data, 'POST');
// 添加路径
export const reqAddPathTemplate = data => ajax('/Path/addPathTemplate', data, 'POST');
// 删除路径
export const reqDeletePathTemplate = data => ajax('/Path/deletePathTemplate', data, 'POST');
// 查看路径详情
export const reqPathDetailList = data => ajax('/Path/pathinfoIndex', data, 'POST');
// 根据天数查看内容
export const reqContentByDay = data => ajax('/Path/selectTreatment', data, 'POST');
// 增加天数
export const reqAddDay = data => ajax('/Path/addLink', data, 'POST');
// 修改天数
export const reqUpdateDay = data => ajax('/Path/updateLink', data, 'POST');
// 删除天数
export const reqDeleteDay = data => ajax('/Path/deleteLink', data, 'POST');
// 增加内容
export const reqAddTreatment = data => ajax('/Path/addTreatment', data, 'POST');
// 修改内容
export const reqUpdateTreatment = data => ajax('/Path/updateTreatment', data, 'POST');
// 删除内容
export const reqDeleteTreatment = data => ajax('/Path/deleteTreatment', data, 'POST');
// 查询患者列表及搜索
export const reqPatientList = data => ajax('/Patient/selectPatient', data, 'POST');
// 获取病种列表
export const reqIllnessList = () => ajax('/Patient/diseaseType', {}, 'POST');
// 新增患者
export const reqAddIllness = data => ajax('/Patient/addPatient', data, 'POST');
// 删除患者
export const reqDeleteIllness = data => ajax('/Patient/deletePatient', data, 'POST');
// 获取患者详情
export const reqIllnessDetail = data => ajax('/Patient/patientInfo', data, 'POST');
// 提交变异原因
export const reqMutations = data => ajax('/Patient/mutations', data, 'POST');
// 提交路径完成
export const reqPathComplete = data => ajax('/Patient/complete', data, 'POST');
// 路径变化
export const reqPathChange = data => ajax('/Patient/updatePatientForm', data, 'POST');
// 统计变异率
export const reqCountChange = () => ajax('/Statistics/mutationRate', {}, 'POST');
// 路径使用率
export const reqCountUse = () => ajax('/Statistics/usageRate', {}, 'POST');