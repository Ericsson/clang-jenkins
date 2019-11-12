node {
    parameters {
        string(name: 'P_MONOREPO_FORK', defaultValue: 'llvm')
        string(name: 'P_MONOREPO_BRANCH', defaultValue: 'master')
        string(name: 'P_PARALLEL_BUILD', defaultValue: '8')
        string(name: 'P_SCRIPT_PATH', defaultValue: '$JENKINS_HOME/ctu-clang-master-monorepo/clang_jenkins/jenkins_home')
    }
    def cc_port = "8004"
    stage('Display parameters') {
        echo "${params.P_MONOREPO_FORK} ${params.P_MONOREPO_BRANCH} ${params.P_PARALLEL_BUILD} ${params.P_SCRIPT_PATH}"
    }
    try {
        stage('Clang SCM checkout/poll') {
            checkout ( [$class: 'GitSCM',
                    branches: [[name: "${params.P_MONOREPO_BRANCH}"]],
                    userRemoteConfigs: [[
                        url: "https://github.com/${params.P_MONOREPO_FORK}/llvm-project.git"]],
                    extensions: [[$class: 'RelativeTargetDirectory',
                        relativeTargetDir: 'llvm-project']],
            ])
        }
        stage('Build and test') {
            sh "cd $WORKSPACE && bash -x ${params.P_SCRIPT_PATH}/build_test_ctu-clang-master-monorepo.sh ${params.P_PARALLEL_BUILD}"
        }
        stage('Analyze open projects (C)') {
            sh "cd $WORKSPACE && bash -x ${params.P_SCRIPT_PATH}/run_clang_on_projects.sh " +
               "${params.P_SCRIPT_PATH} " +
               "${params.P_SCRIPT_PATH}/ctu_pipeline_aux/codechecker " +
               "release " +
               "${params.P_SCRIPT_PATH}/c_projects_jenkins.json ${params.P_PARALLEL_BUILD} " +
               "--fail-on-assert"
            sh "mkdir -p $WORKSPACE/projects/c_reports"
            sh "cp $WORKSPACE/projects/stats.html $WORKSPACE/projects/c_reports/stats.html"
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true,
                reportDir: 'projects/c_reports', reportFiles: 'stats.html',
                reportName: 'CTU results on open projects (C)', reportTitles: 'Open Source (C)'])
        }
        stage('Analyze open projects (C++)') {
            sh "cd $WORKSPACE && bash -x ${params.P_SCRIPT_PATH}/run_clang_on_projects.sh " +
               "${params.P_SCRIPT_PATH} " +
               "${params.P_SCRIPT_PATH}/ctu_pipeline_aux/codechecker " +
               "release " +
               "${params.P_SCRIPT_PATH}/cpp_projects_jenkins.json ${params.P_PARALLEL_BUILD} " +
               "--fail-on-assert"
            sh "mkdir -p $WORKSPACE/projects/cpp_reports"
            sh "cp $WORKSPACE/projects/stats.html $WORKSPACE/projects/cpp_reports/stats.html"
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true,
                reportDir: 'projects/cpp_reports', reportFiles: 'stats.html',
                reportName: 'CTU Results on open projects (C++)', reportTitles: 'Open Source (C++)'])
        }
		} catch (exc) {
        currentBuild.result = 'FAIL'
        result = "FAIL"
        emailext (
            subject: "CTU failed with Clang master! '${env.JOB_NAME}'",
            body: "Check console output at ${env.BUILD_URL}/console",
            to: "gabor.marton@ericsson.com; daniel.krupp@ericsson.com; gyorgy.orban@ericsson.com",
            from: "jenkins@codechecker-buildbot.eastus.cloudapp.azure.com"
        )
    }
}
