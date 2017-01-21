package main

import (
	"math/rand"
	"net/http"
	"time"

	log "github.com/Sirupsen/logrus"

	"os"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	go tick()
	startMetrics()
}

var (
	generatorCounter = prometheus.NewCounter(prometheus.CounterOpts{
		Namespace: "dksto",
		Name:      "generator_count",
		Help:      "Number of generated messages.",
		// ConstLabels:
	})
)

func init() {
	// Seed for rand
	rand.Seed(time.Now().UTC().UnixNano())
	// Metrics have to be registered to be exposed:
	prometheus.MustRegister(generatorCounter)
}

func tick() {
	rate := rand.Intn(10) + 5 // 5-15
	ticker := time.NewTicker(time.Millisecond * 1000)
	for t := range ticker.C {
		generatorCounter.Add(float64(rate))
		log.WithFields(log.Fields{
			"stamp": t.Round(time.Millisecond * 10),
			"rate":  rate,
		}).Info("Tick")
	}
}

func getenv(key, fallback string) string {
	value := os.Getenv(key)
	if len(value) == 0 {
		return fallback
	}
	return value
}

// Start the generator
func startMetrics() {

	// The Handler function provides a default handler to expose metrics
	// via an HTTP server. "/metrics" is the usual endpoint for that.
	http.Handle("/metrics", promhttp.Handler())
	port := getenv("PORT", "8080")
	log.WithFields(log.Fields{
		"port": port,
	}).Info("generator starting")
	log.Fatal(http.ListenAndServe(":"+port, nil))

}
