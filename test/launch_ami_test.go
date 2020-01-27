package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

const launchAmiTestName = "launchAmiTest"

func TestLaunchAmi(t *testing.T) {
	t.Parallel()

	rootModulePath := test_structure.CopyTerraformFolderToTemp(t, "./", "fixtures/launch-ami")

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, rootModulePath)
		terraform.Destroy(t, terraformOptions)
		keyPair := test_structure.LoadEc2KeyPair(t, rootModulePath)
		aws.DeleteEC2KeyPair(t, keyPair)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions, keyPair := configureAmiTerraformOptions(t, rootModulePath)
		test_structure.SaveTerraformOptions(t, rootModulePath, terraformOptions)
		test_structure.SaveEc2KeyPair(t, rootModulePath, keyPair)
		terraform.InitAndApply(t, terraformOptions)
	})
}

func configureAmiTerraformOptions(t *testing.T, modulePath string) (*terraform.Options, *aws.Ec2Keypair) {
	uniqueID := random.UniqueId()

	// get the region from the environment. public access is not allowed
	keyPairName := fmt.Sprintf("%s-%s", launchAmiTestName, uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, "us-west-2", keyPairName)

	terraformOptions := &terraform.Options{
		TerraformDir: modulePath,
		Vars: map[string]interface{}{
			"name":     fmt.Sprintf("%s-%s", launchAmiTestName, uniqueID),
			"key_name": keyPair.Name,
		},
	}

	return terraformOptions, keyPair
}
