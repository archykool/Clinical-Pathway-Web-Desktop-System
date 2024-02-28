<template>
    <div id="Table">
        <a-table class="tag-table"
                 :columns="columns"
                 :dataSource="dataSource"
                 :pagination="pagination"
                 :rowKey="rowKey">
            <template slot="operation">
                <a href="javascript:;">Delete</a>
            </template>
        </a-table>
    </div>
</template>

<script>
    export default {
        name: "Table",
        props: ['columns', 'dataSource', 'pagination', 'rowKey'],
        mounted() {
            console.log(this);
        }
    }
</script>

<style lang="less">
    .tag-table {
        .ant-table {
            table {
                border-collapse: separate;
                border-spacing: 0 8px;
                .ant-table-thead {
                    border-spacing: 0;
                }
                th, td{
                    text-align: center;
                }
            }
        }
        .ant-table-thead > tr {
            box-shadow: 0px 1px 3px 0px #f1f2f5;
            th {
                background: #fff;
                height: 40px;
                padding: 0 16px;
                line-height: 40px;
                color: #5f8ac9;
                font-size: 14px;
                font-weight: bold;
                // text-align: center;
            }
        }
        .ant-table-tbody > tr {
            box-shadow: 0px 1px 3px 0px #f1f2f5;
            td {
                border-bottom: 0;
                background: #fff;
            }
        }
        .ant-table-selection-column {
            border-spacing: 0;
        }

        .ant-table-thead > tr.ant-table-row-hover:not(.ant-table-expanded-row) > td, .ant-table-tbody > tr.ant-table-row-hover:not(.ant-table-expanded-row) > td, .ant-table-thead > tr:hover:not(.ant-table-expanded-row) > td, .ant-table-tbody > tr:hover:not(.ant-table-expanded-row) > td{
            background: #fff;
        }

    }
</style>