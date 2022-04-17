package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestUnitMinimal(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-minimal",
		Vars: map[string]interface{}{
			"gcp_project":    os.Getenv("TEST_GCP_PROJECT"),
			"gcp_org_domain": os.Getenv("TEST_GCP_ORG_DOMAIN"),
		},
		Upgrade: true,
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndPlan(t, terraformOptions)
	// terraform.ApplyAndIdempotent(t, terraformOptions)

	// Replace ApplyAndIdempotent() check with below code if provider and terraform report output changes that
	// can not be prevented due to some bugs in this feature

	// terraform.Apply(t, terraformOptions)

	// stdout := terraform.Plan(t, terraformOptions)

	// resourceCount := terraform.GetResourceCount(t, stdout)
	// assert.Equal(t, 0, resourceCount.Add, "No resources should have been created. Found %d instead.", resourceCount.Add)
	// assert.Equal(t, 0, resourceCount.Change, "No resources should have been changed. Found %d instead.", resourceCount.Change)
	// assert.Equal(t, 0, resourceCount.Destroy, "No resources should have been destroyed. Found %d instead.", resourceCount.Destroy)
}
