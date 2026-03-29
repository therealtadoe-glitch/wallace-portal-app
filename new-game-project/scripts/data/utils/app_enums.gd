extends RefCounted
class_name AppEnums

enum EmployeeStatus {
	INACTIVE,
	ACTIVE,
	ON_LEAVE,
	TERMINATED
}

enum InventoryStatus {
	IN_STOCK,
	LOW_STOCK,
	OUT_OF_STOCK,
	DISCONTINUED
}

enum EquipmentCondition {
	EXCELLENT,
	GOOD,
	FAIR,
	NEEDS_REPAIR,
	OUT_OF_SERVICE
}

enum EquipmentAction {
	CHECKOUT,
	RETURN,
	MAINTENANCE,
	INSPECTION
}

enum JobStatus {
	DRAFT,
	SCHEDULED,
	IN_PROGRESS,
	ON_HOLD,
	COMPLETED,
	CANCELLED
}

enum WorkType {
	MOWING,
	TRIMMING,
	IRRIGATION,
	CLEANUP,
	HARDSCAPE,
	OTHER
}

enum Priority {
	LOW,
	NORMAL,
	HIGH,
	URGENT
}

const DISPLAY_MAP: Dictionary = {
	"EmployeeStatus": {
		EmployeeStatus.INACTIVE: "Inactive",
		EmployeeStatus.ACTIVE: "Active",
		EmployeeStatus.ON_LEAVE: "On Leave",
		EmployeeStatus.TERMINATED: "Terminated"
	},
	"InventoryStatus": {
		InventoryStatus.IN_STOCK: "In Stock",
		InventoryStatus.LOW_STOCK: "Low Stock",
		InventoryStatus.OUT_OF_STOCK: "Out of Stock",
		InventoryStatus.DISCONTINUED: "Discontinued"
	},
	"EquipmentCondition": {
		EquipmentCondition.EXCELLENT: "Excellent",
		EquipmentCondition.GOOD: "Good",
		EquipmentCondition.FAIR: "Fair",
		EquipmentCondition.NEEDS_REPAIR: "Needs Repair",
		EquipmentCondition.OUT_OF_SERVICE: "Out Of Service"
	},
	"JobStatus": {
		JobStatus.DRAFT: "Draft",
		JobStatus.SCHEDULED: "Scheduled",
		JobStatus.IN_PROGRESS: "In Progress",
		JobStatus.ON_HOLD: "On Hold",
		JobStatus.COMPLETED: "Completed",
		JobStatus.CANCELLED: "Cancelled"
	},
	"Priority": {
		Priority.LOW: "Low",
		Priority.NORMAL: "Normal",
		Priority.HIGH: "High",
		Priority.URGENT: "Urgent"
	},
	"WorkType": {
		WorkType.MOWING: "Mowing",
		WorkType.TRIMMING: "Trimming",
		WorkType.IRRIGATION: "Irrigation",
		WorkType.CLEANUP: "Cleanup",
		WorkType.HARDSCAPE: "Hardscape",
		WorkType.OTHER: "Other"
	}
}

static func display_name(group: String, value: int) -> String:
	if not DISPLAY_MAP.has(group):
		return str(value)
	return str(DISPLAY_MAP[group].get(value, str(value)))
