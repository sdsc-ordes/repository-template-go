package cmd

import (
	"log/slog"

	"github.com/spf13/cobra"
)

// CreateRootCmd creates the root command.
func CreateRootCmd(log *slog.Logger) *cobra.Command {
	return &cobra.Command{
		Use:   "cli",
		Short: "Demo is a simple CLI application",
		Run: func(_cmd *cobra.Command, _args []string) {
			log.Info("Welcome to the Cobra Demo!")
		},
	}
}
