package main

import (
	"log/slog"
	"os"

	"github.com/golang-cz/devslog"
	"github.com/swissdatasciencecenter/my-project/tool/tool/cmd/cli/cmd"
	"github.com/swissdatasciencecenter/my-project/tool/tool/cmd/cli/cmd/greet"
)

func main() {
	opts := &devslog.Options{
		MaxSlicePrintSize: 4, //nolint:mnd
		SortKeys:          true,
		TimeFormat:        "[04:05]",
		NewLineAfterLog:   true,
		DebugColor:        devslog.Magenta,
		StringerFormatter: true,
	}
	log := slog.New(devslog.NewHandler(os.Stdout, opts))

	rootCmd := cmd.CreateRootCmd(log)
	greet.Add(rootCmd, log)

	if err := rootCmd.Execute(); err != nil {
		log.Error("Error occurred", "error", err)
		os.Exit(1)
	}
}
